import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_blue_plus/flutter_blue_plus.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:dosewise/ble/ble_manager.dart";
import "package:dosewise/screens/screen_resposta.dart";
import "package:dosewise/veri_device.dart";

class ScreenEndAjudarConv extends StatefulWidget {
  final String uso;
  final String dose;
  final String sintomas;
  final String ano;
  final String altura;
  final String peso;
  final String genero;
  final String doenca_pre_existente;

  const ScreenEndAjudarConv({
    super.key,
    required this.uso,
    required this.dose,
    required this.sintomas,
    required this.ano,
    required this.altura,
    required this.peso,
    required this.genero,
    required this.doenca_pre_existente,
  });

  @override
  ScreenEndAjudarConvState createState() => ScreenEndAjudarConvState();
}

class ScreenEndAjudarConvState extends State<ScreenEndAjudarConv> {
  late StreamSubscription<BluetoothConnectionState> _connSub;
  late StreamSubscription<GlucoseMeasurement> _glucoseSub;
  BluetoothConnectionState _connState = BluetoothConnectionState.disconnected;
  GlucoseMeasurement? _lastMeasurement;

  @override
  void initState() {
    super.initState();
    BleManager.instance.checkConnection();
    _connSub = BleManager.instance.stateStream.listen((state) {
      setState(() => _connState = state);
      if (state == BluetoothConnectionState.connected) {
        BleManager.instance.requestLastRecord();
      }
    });
    _glucoseSub =
        BleManager.instance.glucoseMeasurementStream.listen((meas) {
      setState(() => _lastMeasurement = meas);
    });
  }

  @override
  void dispose() {
    _connSub.cancel();
    _glucoseSub.cancel();
    super.dispose();
  }

  Future<void> _scanAndConnect() async {
    await BleManager.instance.scanAndConnect();
  }

  void _avancarSemMedicao() {
    endAjudarConv(null);
  }

  Future<void> endAjudarConv(double? glicemia) async {
    final double doseDouble = double.tryParse(widget.dose) ?? 0.0;

    // Calcula idade a partir do ano de nascimento
    final int anoNasc = int.tryParse(widget.ano) ?? DateTime.now().year;
    final int idade = DateTime.now().year - anoNasc;
    final int alturaCm = int.tryParse(widget.altura) ?? 0;
    final double pesoKg = double.tryParse(widget.peso) ?? 0.0;

    // Substitui pela tua URL real
      final uri = await makeApiUri("/predict_overdose");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? prefs.getString("auth_token");

    final Map<String, dynamic> payload = {
      "uso_suspeito": widget.uso,
      "dose_g": doseDouble,
      "sintomas": widget.sintomas,
      "idade": idade,
      "altura_cm": alturaCm,
      "peso_kg": pesoKg,
      "genero": widget.genero,
      "doenca_pre_existente": widget.doenca_pre_existente,
      "glicemia": glicemia,
    };

    final bodyJson = jsonEncode(payload);
    print("➡️ JSON a ser enviado: $bodyJson");

    try {
      final response = await http.post(uri, headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: bodyJson,
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ScreenResposta(resposta: jsonDecode(response.body)),
          ),
        );
      } else {
        throw Exception(
            "Erro ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha ao enviar dados: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isConnected =
        _connState == BluetoothConnectionState.connected;
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
              isConnected
                  ? "✅ Dispositivo conectado"
                  : "❌ Dispositivo não conectado",
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
                minimumSize:
                    Size(size.width * 0.6, size.height * 0.06),
                backgroundColor: colorScheme.secondary,
                foregroundColor: colorScheme.onSecondary,
                textStyle: TextStyle(
                    fontSize: size.width * 0.045),
              ),
              child: const Text("Escanear e conectar"),
            ),
            SizedBox(height: size.height * 0.05),

            if (_lastMeasurement != null) ...[
              Card(
                color: colorScheme.secondaryContainer,
                margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.02),
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.04),
                  child: Column(
                    children: [
                      Icon(
                        Icons.opacity,
                        size: size.width * 0.12,
                        color: colorScheme.primary,
                      ),
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
                          color:
                              colorScheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              ElevatedButton.icon(
                onPressed: () =>
                    endAjudarConv(_lastMeasurement!.concentration),
                icon:
                    Icon(Icons.send, size: size.width * 0.06),
                label: Text(
                  "Finalizar Ajuda",
                  style: TextStyle(
                      fontSize: size.width * 0.045),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                      size.width * 0.6, size.height * 0.06),
                  backgroundColor: colorScheme.primary,
                  foregroundColor:
                      colorScheme.onSecondary,
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
              SizedBox(height: size.height * 0.03),
              ElevatedButton.icon(
                onPressed: _avancarSemMedicao,
                icon:
                    Icon(Icons.skip_next, size: size.width * 0.06),
                label: Text(
                  "Avançar sem medir glicemia",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: size.width * 0.045),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                      size.width * 0.6, size.height * 0.1),
                  backgroundColor: colorScheme.secondary,
                  foregroundColor:
                      colorScheme.onSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
