import 'dart:async';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BleManager {
  //final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance();
  BluetoothDevice? _device;
  BluetoothCharacteristic? _glucoseChar;

  final StreamController<double> _glucoseController = StreamController.broadcast();
  Stream<double> get glucoseStream => _glucoseController.stream;

  Future<void> startScanAndConnect() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        if (r.device.name.contains('Accu') || r.device.name.contains('Chek')) {
          _device = r.device;
          await FlutterBluePlus.stopScan();
          await _connectToDevice();
          break;
        }
      }
    });
  }

  Future<void> _connectToDevice() async {
    if (_device == null) return;

    await _device!.connect(autoConnect: true);
    List<BluetoothService> services = await _device!.discoverServices();

    for (var service in services) {
      if (service.uuid.toString().toLowerCase().startsWith('00001808')) {
        for (var char in service.characteristics) {
          if (char.uuid.toString().toLowerCase().endsWith('2a18')) {
            _glucoseChar = char;
            await _subscribeToNotifications();
            return;
          }
        }
      }
    }
  }

  Future<void> _subscribeToNotifications() async {
    if (_glucoseChar == null) return;

    await _glucoseChar!.setNotifyValue(true);
    _glucoseChar!.value.listen((data) async {
      if (data.length >= 2) {
        int raw = (data[1] << 8) | data[0];
        int mantissa = raw & 0x0FFF;
        int exponent = (raw >> 12) & 0x000F;
        if (exponent >= 0x0008) exponent = exponent - 16;
        double glucose = mantissa * pow(10, exponent).toDouble();
        _glucoseController.add(glucose);

        print("[INFO] Glicemia lida: $glucose mg/dL");
        await enviarGlicoseParaBackend(glucose);
      }
    });
  }

  Future<void> enviarGlicoseParaBackend(double glicemia) async {
    final uri = Uri.parse("http://<TEU_BACKEND>:8000/predict_overdose");
    final body = jsonEncode({
      "idade": 30,
      "peso_kg": 70.0,
      "glicemia": glicemia,
      "sintomas": "confusao e sonolencia",
      "uso_suspeito": "Drogas"
    });

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final resposta = jsonDecode(response.body);
        print("[INFO] Risco de overdose: ${resposta['risk_score']}");
      } else {
        print("[ERRO] Falha ao enviar glicose: ${response.statusCode}");
      }
    } catch (e) {
      print("[ERRO] Excecao ao enviar glicose: $e");
    }
  }

  Future<void> disconnect() async {
    await _device?.disconnect();
    _glucoseController.close();
  }
}