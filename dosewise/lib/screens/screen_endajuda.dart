import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:dosewise/ble/ble_manager.dart";
import "package:dosewise/veri_device.dart";
import "package:dosewise/screens/screen_resposta.dart";

class ScreenEndAjuda extends StatefulWidget {
  final String uso;
  final String dose;
  final String sintomas;

  const ScreenEndAjuda({
    super.key,
    required this.uso,
    required this.dose,
    required this.sintomas,
  });

  @override
  ScreenEndAjudaState createState() => ScreenEndAjudaState();
}

class ScreenEndAjudaState extends State<ScreenEndAjuda> {
  late StreamSubscription<BluetoothConnectionState> _connSub;
  late StreamSubscription<GlucoseMeasurement> _glucoseSub;

  BluetoothConnectionState _connState = BluetoothConnectionState.disconnected;
  GlucoseMeasurement? _lastMeasurement;

  bool _loadingProfile = true;
  String? _profileError;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    BleManager.instance.checkConnection();
    _connSub = BleManager.instance.stateStream.listen((state) {
      setState(() => _connState = state);
      if (state == BluetoothConnectionState.connected) {
        BleManager.instance.requestLastRecord();
      }
    });
    _glucoseSub = BleManager.instance.glucoseMeasurementStream.listen((meas) {
      setState(() => _lastMeasurement = meas);
    });
  }

  @override
  void dispose() {
    _connSub.cancel();
    _glucoseSub.cancel();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _loadingProfile = true;
      _profileError = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? prefs.getString("auth_token");
      if (token == null) {
        throw Exception("Token não encontrado");
      }
      final uri = await makeApiUri("/users/me");
      final resp = await http.get(
        uri,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      );
      if (resp.statusCode == 200) {
        setState(() {
          _loadingProfile = false;
        });
      } else {
        throw Exception("Erro ${resp.statusCode}");
      }
    } catch (e) {
      setState(() {
        _profileError = "Falha ao carregar perfil: $e";
        _loadingProfile = false;
      });
    }
  }

  Future<void> _scanAndConnect() async => BleManager.instance.scanAndConnect();

  Future<void> finalizarAjuda() async {
    final double doseDouble = double.tryParse(widget.dose) ?? 0.0;
    final uri = await makeApiUri("/predict_overdose");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? prefs.getString("auth_token");

    final Map<String, dynamic> payload = {
      "uso_suspeito": widget.uso,
      "dose_g": doseDouble,
      "sintomas": [widget.sintomas],
      "glicemia": _lastMeasurement?.concentration,
    };

    final bodyJson = jsonEncode(payload);
    print("➡️ JSON a ser enviado: $bodyJson");

    try {
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: bodyJson,
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados adicionados com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ScreenResposta(resposta: jsonDecode(response.body)),
          ),
        );
      } else {
        print("◀️ Erro ${response.statusCode}: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao adicionar os seus dados: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na requisição: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingProfile) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_profileError != null) {
      return Scaffold(
        body: Center(child: Text(_profileError!)),
      );
    }

    final isConnected = _connState == BluetoothConnectionState.connected;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.2,
          vertical: size.height * 0.04,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isConnected ? "✅ Dispositivo conectado" : "❌ Não conectado",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            ElevatedButton(
              onPressed: _scanAndConnect,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(size.width * 0.6, size.height * 0.06),
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                textStyle: TextStyle(fontSize: size.width * 0.045),
              ),
              child: Text("Escanear e conectar"),
            ),
            SizedBox(height: size.height * 0.05),
            if (_lastMeasurement != null) ...[
              Card(
                color: colorScheme.secondaryContainer,
                margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    children: [
                      Icon(Icons.opacity, size: size.width * 0.12, color: colorScheme.primary),
                      SizedBox(height: size.height * 0.015),
                      Text(
                        "${_lastMeasurement!.concentration.toStringAsFixed(1)} mg/dL",
                        style: TextStyle(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        "${_lastMeasurement!.timestamp.toLocal()}",
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              ElevatedButton.icon(
                onPressed: finalizarAjuda,
                icon: Icon(Icons.send, size: size.width * 0.06),
                label: Text(
                  "Finalizar Ajuda",
                  style: TextStyle(fontSize: size.width * 0.045),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * 0.6, size.height * 0.06),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.secondary,
                ),
              ),
            ] else ...[
              Text(
                "Aguardando última medição...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.05,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
