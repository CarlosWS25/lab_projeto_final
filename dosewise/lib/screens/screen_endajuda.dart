import "dart:convert";
import "package:dosewise/screens/home_screen.dart";
import "package:http/http.dart" as http;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/veri_device.dart";

class ScreenEndAjuda extends StatefulWidget{
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

  class ScreenEndAjudaState extends State<ScreenEndAjuda>{

  Future<void> finalizarAjuda() async {

    final double? doseDouble = double.tryParse(widget.dose); 

    final uri = await makeApiUri("/predict_overdose");


    try {
      // Envia os dados do utilizador para a Base de Dados
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "doencas": widget.doencas,
          "sintomas": widget.sintomas,
          "uso_suspeito": widget.uso,
          "dose_g": doseDouble,
        }),
      );

    if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados adicionados com sucesso!")),
        );
        //final data = jsonDecode(response.body);
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        }else {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar Ajuda"),
      ),
      body: Center(
        /*child: ElevatedButton(
          onPressed: finalizarAjuda(),
          child: const Text("Finalizar"),
        ),*/
      ),
    );
  }
  }

