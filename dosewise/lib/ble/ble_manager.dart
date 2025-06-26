import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleManager {
  BluetoothDevice? _device;
  BluetoothCharacteristic? _glucoseChar;
  StreamSubscription<BluetoothConnectionState>? _connectionSubscription;

  final StreamController<double> _glucoseController = StreamController.broadcast();
  Stream<double> get glucoseStream => _glucoseController.stream;

  Future<void> startScanAndConnect() async {
  print("🔍 Iniciando scan BLE...");

  await FlutterBluePlus.startScan();

  late StreamSubscription<List<ScanResult>> subscription;

  subscription = FlutterBluePlus.scanResults.listen((results) async {
    for (var r in results) {
      final name = r.device.name.toLowerCase();

      // Só mostra e conecta se o nome for válido
      if (name.contains("accu") || name.contains("chek") || name.contains("meter")) {
        print("🔍 Dispositivo encontrado: '${r.device.name}' | ID: ${r.device.id.id}");

        await FlutterBluePlus.stopScan();
        await subscription.cancel();

        _device = r.device;

        final alreadyConnected = await _device!.state.first == BluetoothDeviceState.connected;
        if (alreadyConnected) {
          print("⚠️ Dispositivo já está conectado.");
          return;
        }

        print("🔗 A tentar conectar a: ${_device!.id.id} (${_device!.name})");

        await _setupConnectionListener();
        await _connectToDevice();
        await _discoverServicesAndListen();
        break;
      }
    }
  });
}


  Future<void> _setupConnectionListener() async {
    if (_device == null) return;

    _connectionSubscription =
        _device!.connectionState.listen((BluetoothConnectionState state) {
      print('📡 Estado da ligação BLE: $state');
    });
  }

  Future<void> _connectToDevice() async {
    if (_device == null) return;

    try {
      await _device!.connect(timeout: const Duration(seconds: 10));
      print("🔗 Dispositivo conectado: ${_device!.name}");
    } on TimeoutException {
      print("⏱️ Conexão excedeu o tempo limite.");
    } catch (e) {
      print("❌ Erro ao conectar ao dispositivo: $e");
    }
  }

  Future<void> _discoverServicesAndListen() async {
    if (_device == null) return;

    try {
      List<BluetoothService> services = await _device!.discoverServices();
      print("🔬 Serviços descobertos: ${services.length}");

      for (BluetoothService service in services) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.properties.notify || characteristic.properties.indicate) {
            print("📨 Found characteristic notifiable: ${characteristic.uuid}");

            await Future.delayed(Duration(seconds: 2));
            await characteristic.setNotifyValue(true);

            characteristic.value.listen((value) async {
              if (value.isNotEmpty) {
                double? glicemia = _parseGlucoseValue(value);

                if (glicemia != null) {
                  print("📈 Leitura BLE recebida: $value → glicemia: $glicemia");
                  _glucoseController.add(glicemia);

                  // Depois da primeira leitura, desliga o notify e desconecta
                  try {
                    await characteristic.setNotifyValue(false);
                    await _device?.disconnect();
                  } catch (e) {
                    print("⚠️ Erro ao terminar ligação BLE: $e");
                  }
                } else {
                  print("⚠️ Não foi possível interpretar os dados: $value");
                }
              } else {
                print("⚠️ Leitura vazia recebida.");
              }
            });


            _glucoseChar = characteristic;
            return;
          }
        }
      }

      print("❗ Nenhum characteristic notifiable encontrado!");
    } catch (e) {
      print("❌ Erro ao descobrir serviços/características: $e");
    }
  }

  double? _parseGlucoseValue(List<int> value) {
    // Este parser é genérico. Ajusta conforme protocolo real do dispositivo.
    if (value.length >= 2) {
      int raw = value[0] | (value[1] << 8);  // little endian
      return raw / 10.0; // ex: 935 → 93.5 mg/dL
    }
    return null;
  }

  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    await _glucoseController.close();

    if (_device != null) {
      try {
        await _device!.disconnect();
      } catch (e) {
        print("⚠️ Erro ao desconectar: $e");
      }
    }

    print("🔌 BLE Manager disposed");
  }
}
