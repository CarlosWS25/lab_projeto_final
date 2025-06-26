import "dart:convert";
import "package:dosewise/screens/home_screen.dart";
import "package:http/http.dart" as http;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/ble/ble_manager.dart";
import "package:permission_handler/permission_handler.dart";
import "package:dosewise/veri_device.dart";

class ScreenEndAjuda extends StatefulWidget {
  final String uso;
  final String dose;
  final String sintomas;
  final String doencas;

  const ScreenEndAjuda({
    super.key,
    required this.uso,
    required this.dose,
    required this.doencas,
    required this.sintomas,
  });

  @override
  State<ScreenEndAjuda> createState() => ScreenEndAjudaState();
}

class ScreenEndAjudaState extends State<ScreenEndAjuda> {
  final BleManager bleManager = BleManager();

  double? glicemia;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    requestPermissions().then((_) async {
      await bleManager.startScanAndConnect();

      bleManager.glucoseStream.listen((value) {
        if (mounted) {
          setState(() {
            glicemia = value;
            isLoading = false;
          });
        }
      });
    });
  }

  Future<void> requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  Future<void> finalizarAjuda() async {
    final double? doseDouble = double.tryParse(widget.dose);
    final uri = await makeApiUri("/predict_overdose");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "doencas": widget.doencas,
          "sintomas": widget.sintomas,
          "uso_suspeito": widget.uso,
          "dose_g": doseDouble,
          "glicemia": glicemia, // Incluído, se a API suportar
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados adicionados com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
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
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Finalizar Ajuda",
          style: TextStyle(fontSize: size.width * 0.06),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Center(
          child: isLoading || glicemia == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    SizedBox(height: size.height * 0.03),
                    Text(
                      "À espera da leitura da glicemia...",
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Glicemia: ${glicemia!.toStringAsFixed(1)} mg/dL",
                      style: TextStyle(
                        fontSize: size.width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    SizedBox(
                      width: size.width * 0.6,
                      height: size.height * 0.08,
                      child: ElevatedButton(
                        onPressed: finalizarAjuda,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                        ),
                        child: Text(
                          "Finalizar",
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
