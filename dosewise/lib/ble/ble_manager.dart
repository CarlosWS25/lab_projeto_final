import 'dart:async';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleManager {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _glucoseChar;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  final StreamController<double> _glucoseController = StreamController.broadcast();
  Stream<double> get glucoseStream => _glucoseController.stream;

  Future<void> startScanAndConnect() async {
    // Começa o scan
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        if (r.device.name.contains('Accu') || r.device.name.contains('Chek')) {
          _device = r.device;
          await FlutterBluePlus.stopScan();
          await _setupConnectionListener(); // <- novo
          await _connectToDevice();
          break;
        }
      }
    });
  }

  Future<void> _setupConnectionListener() async {
    if (_device == null) return;

    _connectionSubscription?.cancel();
    _connectionSubscription = _device!.connectionState.listen((state) async {
      if (state == BluetoothConnectionState.connected) {
        print('[INFO] Conectado ao dispositivo');
        await _discoverAndSubscribe();
      } else if (state == BluetoothConnectionState.disconnected) {
        print('[INFO] Desconectado. Tentando reconectar...');
        Future.delayed(const Duration(seconds: 2), () => _connectToDevice());
      }
    });
  }

  Future<void> _connectToDevice() async {
    if (_device == null) return;

    final currentState = await _device!.connectionState.first;
    if (currentState == BluetoothConnectionState.connected) {
      print('[INFO] Já conectado');
      return;
    }

    try {
      await _device!.connect(autoConnect: true);
    } catch (e) {
      print('[ERRO] Erro ao conectar: $e');
    }
  }

  Future<void> _discoverAndSubscribe() async {
    if (_device == null) return;

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

    _glucoseChar!.value.listen((data) {
      if (data.length >= 2) {
        int raw = (data[1] << 8) | data[0];
        int mantissa = raw & 0x0FFF;
        int exponent = (raw >> 12) & 0x000F;
        if (exponent >= 0x0008) exponent -= 16;
        double glucose = mantissa * pow(10, exponent).toDouble();
        _glucoseController.add(glucose);

        print("[INFO] Glicemia lida: $glucose mg/dL");
      }
    });
  }

  Future<void> disconnect() async {
    await _connectionSubscription?.cancel();
    await _device?.disconnect();
    _glucoseController.close();
  }
}
