import "dart:convert";
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:dosewise/veri_device.dart";
import "package:dosewise/opcoes_gdu.dart";
import "package:dosewise/screens/splashscreen_recoverypass.dart";
import 'package:shared_preferences/shared_preferences.dart';

class ScreenEndRegistar extends StatefulWidget {
  final String username;
  final String password;

  const ScreenEndRegistar({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<ScreenEndRegistar> createState() => ScreenEndRegistarState();
}

class ScreenEndRegistarState extends State<ScreenEndRegistar> {
  final TextEditingController anoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController doencaController = TextEditingController();

  List<String> opcoesDoenca = [];

  @override
  void initState() {
    super.initState();
    carregarDoenca().then((value) {
      setState(() => opcoesDoenca = value);
    });
  }

  Future<void> finalizarRegisto() async {
    final ano = anoController.text.trim();
    final altura = alturaController.text.trim();
    final peso = pesoController.text.trim();
    final genero = generoController.text.trim();
    final doenca = doencaController.text.trim();

    if (ano.isEmpty || altura.isEmpty || peso.isEmpty || genero.isEmpty || doenca.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    final int? anoNascimentoInt = int.tryParse(ano);
    final int? alturaInt = int.tryParse(altura);
    final double? pesoDouble = double.tryParse(peso);
    final generoEnviado = mapGenero[genero] ?? genero;

    final uri = await makeApiUri("/users/");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": widget.username,
          "password": widget.password,
          "ano_nascimento": anoNascimentoInt,
          "altura_cm": alturaInt,
          "peso": pesoDouble,
          "genero": generoEnviado,
          "doenca_pre_existente": doenca,
        }),
      );

      switch (response.statusCode) {
        case 200:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Conta criada com sucesso!")),
          );
          final data = jsonDecode(response.body);
          final recoveryKey = data["recovery_key"];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("recovery_key", recoveryKey);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ScreenRecovery(recoveryKey: recoveryKey),
            ),
          );
          break;
        case 409:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Esse nome de utilizador já existe.")),
          );
          break;
        case 422:
          final errors = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Validação falhou: ${errors['detail']}")),
          );
          break;
        case 500:
          debugPrint("SERVER ERROR 500: ${response.body}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Erro interno do servidor. Veja o log.")),
          );
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro ao criar conta: ${response.statusCode}")),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na requisição: $e")),
      );
    }
  }

  @override
  void dispose() {
    anoController.dispose();
    alturaController.dispose();
    pesoController.dispose();
    generoController.dispose();
    doencaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [

// Logo Dosewise
          Positioned(
            top: size.height * 0.08,
            right: size.width * 0.08,
              child: Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/images/logo_dosewise.png"
                    : "assets/images/logo_dosewise_dark.png",
                width: size.width * 0.3,
                height: size.width * 0.3,
              ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.2),

// Título Finalizar Registo
                  Text(
                    "Finalizar Registo",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.08,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Ano de Nascimento
                  TextField(
                    controller: anoController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Ano de Nascimento (YYYY)",
                      hintStyle: TextStyle(color: colorScheme.primary,),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  SizedBox(height: size.height * 0.02),

//Campo Altura (cm)
                  TextField(
                    controller: alturaController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Altura (cm)",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  SizedBox(height: size.height * 0.02),

//Campo Peso (kg)
                  TextField(
                    controller: pesoController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r"^\d{0,3}(\.\d{0,2})?$")),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Peso (kg)",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  SizedBox(height: size.height * 0.02),

//Campo Género
                  TextField(
                    onTap: () => escolherGenero(context: context, controller: generoController),
                    controller: generoController,
                    showCursor: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Género",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Doenças prévias
                  TextField(
                    onTap: () => escolherDoenca(context: context, controller: doencaController, opcoes: opcoesDoenca),
                    controller: doencaController,
                    showCursor: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Doenças prévias",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  SizedBox(height: size.height * 0.05),

// Botão Finalizar Registo
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () async {
                            print("Botão Finalziar Registo pressionado!");
                            finalizarRegisto();
                          },
                          backgroundColor: colorScheme.primary,
                          label: Text(
                            "Finalizar Registo",
                            style: TextStyle(
                              fontFamily: "Roboto-Regular",
                              color: colorScheme.onPrimary,
                              fontSize: size.width * 0.05,
                            ),
                          )
                        ),
                        SizedBox(height: size.height * 0.02),
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],  
      ),
    );
  }
}
