import "dart:io";
import "package:device_info_plus/device_info_plus.dart";
import 'package:wifi_info_flutter/wifi_info_flutter.dart';  // Corrige a importação

const int porta_host = 8000;

Future<String> _getAndroidHost() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  if (androidInfo.isPhysicalDevice) {
    return await _getLocalIP();
  }

  final fingerprint = androidInfo.fingerprint.toLowerCase();
  final model = androidInfo.model.toLowerCase();

  if (fingerprint.contains("genymotion") || model.contains("vbox86p")) {
    return "10.0.3.2";
  }

  return "10.0.2.2";
}

Future<String> _getLocalIP() async {
  final wifiInfo = WifiInfo();
  final ipAddress = await wifiInfo.getWifiIP();
  return ipAddress ?? "192.168.1.74"; 
}

Future<Uri> makeApiUri(String path) async {
  final host = Platform.isAndroid ? await _getAndroidHost() : "192.168.1.74";
  return Uri(
    scheme: "http",
    host: host,
    port: porta_host,
    path: path,
  );
}
