import "dart:io";
import "package:device_info_plus/device_info_plus.dart";


const String enderecoIP_host = "192.168.1.66";
const int porta_host = 8000;


Future<String> _getAndroidHost() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  if (androidInfo.isPhysicalDevice) {
    return enderecoIP_host;
  }

  final fingerprint = androidInfo.fingerprint.toLowerCase();
  final model = androidInfo.model.toLowerCase();

  if (fingerprint.contains("genymotion") || model.contains("vbox86p")) {
    return "10.0.3.2";
  }

  return "10.0.2.2";
}


Future<Uri> makeApiUri(String path) async {
  final host = Platform.isAndroid ? await _getAndroidHost() : "192.168.1.66";
  return Uri(
    scheme: "http",
    host: host,
    port: porta_host,
    path: path,
  );
}
