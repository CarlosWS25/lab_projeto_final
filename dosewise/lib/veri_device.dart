import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int _apiPort = 8000;
const Duration _scanTimeout = Duration(milliseconds: 500);
const int _scanBatchSize = 32;

Future<String> _getCachedHost() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('api_host') ?? '';
}

Future<void> _cacheHost(String host) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('api_host', host);
}

Future<bool> _isAndroidEmulator() async {
  if (!Platform.isAndroid) return false;
  final info = await DeviceInfoPlugin().androidInfo;
  final fp = info.fingerprint?.toLowerCase() ?? '';
  final model = info.model?.toLowerCase() ?? '';
  return (!info.isPhysicalDevice) ||
      fp.contains('genymotion') ||
      model.contains('vbox86p');
}

Future<String> _androidHostFallback() async {
  return await _isAndroidEmulator() ? '10.0.2.2' : '10.0.3.2';
}

Future<String> _scanForHost() async {
  final info = NetworkInfo();
  final wifiIp = await info.getWifiIP();
  final gatewayIp = await info.getWifiGatewayIP();
  print('DEBUG: IP Wi‑Fi = $wifiIp');
  print('DEBUG: Gateway  = $gatewayIp');
  if (wifiIp == null) {
    throw Exception('Não foi possível obter o IP da rede Wi‑Fi');
  }

  final parts = wifiIp.split('.');
  if (parts.length != 4) {
    throw Exception('IP Wi‑Fi inválido: $wifiIp');
  }
  final subnet = '${parts[0]}.${parts[1]}.${parts[2]}';
  print('DEBUG: subnet = $subnet');

  // Gera todos os hosts de .1 a .254, mas ignora o próprio IP e o gateway
  final hosts = <String>[];
  for (var i = 1; i <= 254; i++) {
    final host = '$subnet.$i';
    if (host == wifiIp || host == gatewayIp) continue;
    hosts.add(host);
  }

  for (var i = 0; i < hosts.length; i += _scanBatchSize) {
    final batch = hosts.skip(i).take(_scanBatchSize);
    final futures = batch.map((host) {
      return Socket.connect(host, _apiPort, timeout: _scanTimeout)
          .then((socket) {
        socket.destroy();
        return host;
      }).catchError((_) => null);
    }).toList();

    try {
      final found = await Future.any(futures.where((f) => f != null));
      if (found != null && found is String) {
        print('DEBUG: encontrado host = $found');
        return found;
      }
    } catch (_) {
      // nenhum do batch respondeu, continua
    }
  }

  throw Exception('Servidor não encontrado na LAN após scan');
}

Future<String> _discoverHost() async {
  if (Platform.isAndroid && await _isAndroidEmulator()) {
    return _androidHostFallback();
  }

  final cached = await _getCachedHost();
  if (cached.isNotEmpty) return cached;

  final found = await _scanForHost();
  await _cacheHost(found);
  return found;
}

Future<Uri> makeApiUri(String path) async {
  final host = await _discoverHost();
  final scheme = 'http';
  return Uri(scheme: scheme, host: host, port: _apiPort, path: path);
}
