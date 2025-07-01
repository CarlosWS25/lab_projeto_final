import 'dart:async';
import 'dart:math';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Modelo de registro de glicose
class GlucoseMeasurement {
  final int sequenceNumber;
  final DateTime timestamp;
  final double concentration; // em mg/dL

  GlucoseMeasurement({
    required this.sequenceNumber,
    required this.timestamp,
    required this.concentration,
  });

  @override
  String toString() {
    return 'Seq: $sequenceNumber | Time: $timestamp | Glucose: $concentration mg/dL';
  }
}

class BleManager {
  BleManager._privateConstructor() {
    _stateController.add(BluetoothConnectionState.disconnected);
  }
  static final BleManager instance = BleManager._privateConstructor();

  String targetName = 'meter+07640270';
  String? targetId = '88:0C:E0:A5:42:6F';

  BluetoothDevice? _connectedDevice;
  StreamSubscription<BluetoothConnectionState>? _deviceStateSub;
  StreamSubscription<List<int>>? _measSub;

  final _stateController = StreamController<BluetoothConnectionState>.broadcast();
  final _glucoseMeasurementController = StreamController<GlucoseMeasurement>.broadcast();

  BluetoothCharacteristic? _measChar;
  BluetoothCharacteristic? _racpChar;

  /// Stream de estado de conexão
  Stream<BluetoothConnectionState> get stateStream => _stateController.stream;
  /// Stream da última medição
  Stream<GlucoseMeasurement> get glucoseMeasurementStream => _glucoseMeasurementController.stream;

  Future<bool> _ensureBluetoothOn() async {
    final state = await FlutterBluePlus.adapterState.first;
    return state == BluetoothAdapterState.on;
  }

  /// Verifica conexão atual e atualiza o estado
  Future<bool> checkConnection() async {
    if (!await _ensureBluetoothOn()) return false;
    bool isConnected = false;
    if (_connectedDevice != null) {
      final s = await _connectedDevice!.connectionState.first;
      isConnected = s == BluetoothConnectionState.connected;
    }
    _stateController.add(
      isConnected
          ? BluetoothConnectionState.connected
          : BluetoothConnectionState.disconnected
    );
    return isConnected;
  }

  /// Inicia scan e conecta ao dispositivo alvo
  Future<void> scanAndConnect({ Duration timeout = const Duration(seconds: 5) }) async {
    if (!await _ensureBluetoothOn()) return;
    await FlutterBluePlus.startScan(timeout: timeout);
    final completer = Completer<void>();
    late final StreamSubscription<List<ScanResult>> sub;

    sub = FlutterBluePlus.scanResults.listen((results) async {
      for (var r in results) {
        final name = r.device.name;
        final id = r.device.id.toString();
        if ((targetName.isNotEmpty && name == targetName) ||
            (targetId != null && id == targetId)) {
          await FlutterBluePlus.stopScan();
          await sub.cancel();
          await connectToDevice(r.device);
          completer.complete();
          break;
        }
      }
    });

    await Future.any([completer.future, Future.delayed(timeout)]);
    if (!completer.isCompleted) {
      await FlutterBluePlus.stopScan();
      await sub.cancel();
    }
  }

  /// Conecta e inicializa serviços
  Future<void> connectToDevice(BluetoothDevice device) async {
    if (!await _ensureBluetoothOn()) return;
    _stateController.add(BluetoothConnectionState.connecting);
    await device.connect(timeout: Duration(seconds: 30), autoConnect: false);
    _connectedDevice = device;

    await _deviceStateSub?.cancel();
    _deviceStateSub = device.connectionState.listen((state) {
      _stateController.add(state);
      if (state == BluetoothConnectionState.disconnected) {
        _cleanup();
      }
    });

    final services = await device.discoverServices();
    services.forEach((s) => print('Serviço: ${s.uuid}'));
    await _initGlucoseService(services);

    // Solicita imediatamente a última medição
    await requestLastRecord();
  }

  /// Descobre características de medição e RACP
  Future<void> _initGlucoseService(List<BluetoothService> services) async {
    const measShort = '2a18';
    const racpShort = '2a52';

    for (var s in services) {
      for (var c in s.characteristics) {
        final id = c.uuid.toString().toLowerCase();
        print('Serviço ${s.uuid} - Característica $id');
        if (id.contains(measShort)) {
          _measChar = c;
          for (var c2 in s.characteristics) {
            final id2 = c2.uuid.toString().toLowerCase();
            if (id2.contains(racpShort)) {
              _racpChar = c2;
              break;
            }
          }
          break;
        }
      }
      if (_measChar != null) break;
    }

    if (_measChar == null) {
      throw Exception('Medição (0x2A18) não encontrada');
    }

    // Ativa notificações de medição
    await _measChar!.setNotifyValue(true);
    await _measSub?.cancel();
    _measSub = _measChar!.value.listen(_parseGlucoseMeasurement);

    // Ativa indicações RACP, se houver
    if (_racpChar != null) {
      await _racpChar!.setNotifyValue(true);
    } else {
      print('⚠️ RACP não encontrada, leituras restritas');
    }
  }

  /// Envia comando para obter o último registro
  Future<void> requestLastRecord() async {
    if (_racpChar == null) {
      print('⚠️ RACP não inicializado ainda');
      return;
    }
    await _racpChar!.write([0x01, 0x06], withoutResponse: false);
    print('📤 Último registro solicitado');
  }

  /// Parseia o pacote SFLOAT e converte para mg/dL
  void _parseGlucoseMeasurement(List<int> data) {
    if (data.length < 12) return;
    print('🧩 Raw data bytes: $data');
    final flags = data[0];
    final isMolUnit = (flags & 0x04) != 0;
    final timeOffsetPresent = (flags & 0x01) != 0;
    final typeSamplePresent = (flags & 0x02) != 0;

    int index = 1;
    // Sequence Number
    final seq = data[index++] | (data[index++] << 8);
    // Base Time (7 bytes)
    final year = data[index++] | (data[index++] << 8);
    final month = data[index++];
    final day = data[index++];
    final hour = data[index++];
    final minute = data[index++];
    final second = data[index++];
    final timestamp = DateTime(year, month, day, hour, minute, second);

    // Time Offset (2 bytes) if present
    if (timeOffsetPresent) {
      final offset = data[index++] | (data[index++] << 8);
      print('⏱ Time offset: $offset');
    }
    // Glucose Concentration (SFLOAT - 2 bytes)
    final lsb = data[index++];
    final msb = data[index++];
    final rawSfloat = (msb << 8) | lsb;
    int mantissa = rawSfloat & 0x0FFF;
    if (mantissa >= 0x0800) mantissa -= 0x1000;
    int exponent = (rawSfloat >> 12) & 0x000F;
    if (exponent >= 0x0008) exponent -= 0x0010;
    final valueSi = mantissa * pow(10, exponent);
    print('⚙️ SFLOAT raw=0x${rawSfloat.toRadixString(16)}, mantissa=$mantissa, exponent=$exponent, SI=$valueSi');

    // Type & Sample Location (1 byte each) if present
    if (typeSamplePresent) {
      final type = data[index++];
      final location = data[index++];
      print('🔖 Type=$type, Location=$location');
    }

    // Converter para mg/dL
    double glicemia;
    if (isMolUnit) {
      glicemia = valueSi * 1000 * 18.0;
    } else {
      glicemia = valueSi * 100000.0;
    }

    print('📥 Medição: seq=$seq, time=$timestamp, mg/dL=${glicemia.toStringAsFixed(2)}');
    _glucoseMeasurementController.add(
      GlucoseMeasurement(
        sequenceNumber: seq,
        timestamp: timestamp,
        concentration: glicemia,
      ),
    );
  }

  void _cleanup() {
    _connectedDevice = null;
    _measChar = null;
    _racpChar = null;
    _measSub?.cancel();
  }

  void dispose() {
    _deviceStateSub?.cancel();
    _measSub?.cancel();
    _stateController.close();
    _glucoseMeasurementController.close();
  }
}
