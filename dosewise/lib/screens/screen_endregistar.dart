import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/veri_device.dart";
import "package:dosewise/opcoes_gd.dart";
import "package:dosewise/screens/splashscreen_recoverypass.dart";
import 'package:shared_preferences/shared_preferences.dart';

class ScreenEndRegistar extends StatefulWidget {
  // Campos finais que armazenam os dados do utilizador
  final String username;
  final String password;
  

  // Construtor da classe, com parâmetros obrigatórios
  const ScreenEndRegistar({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<ScreenEndRegistar> createState() => ScreenEndRegistarState();
}

class ScreenEndRegistarState extends State<ScreenEndRegistar> {
  //Controllers que capturam os dados dos TextFields  
  final TextEditingController anoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController recoveryController = TextEditingController();

//Função que completa o registo do utilzador
Future<void> finalizarRegisto() async {
    final ano = anoController.text.trim();
    final altura = alturaController.text.trim();
    final peso = pesoController.text.trim();
    final genero = generoController.text.trim();

    //Validação dos campos
    if (ano.isEmpty || altura.isEmpty || peso.isEmpty || genero.isEmpty ) {
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
      // Envia os dados do utilizador para a Base de Dados
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
        }),
      );
  
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Conta criada com sucesso!")),
        );
        final data = jsonDecode(response.body);
        final recoveryKey = data["recovery_key"];
        print("Recovery key recebida: $recoveryKey");

        // Guardar localmente
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("recovery_key", recoveryKey);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScreenRecovery(recoveryKey: recoveryKey)),
        );
        } else if (response.statusCode == 409) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("❌ Esse nome de utilizador já existe.")),
            );
      } else {
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
  void initState() {
    super.initState();
}


  @override
  //Frontend do ecrã de registo
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [

          //Logo Dosewise
          Positioned(
            top: 50,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
                width: 125,
                height: 125,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),

                  //Título de Finalizar Registo
                  Text("Finalizar Registo",
                  style: TextStyle(
                    fontFamily: "Roboto-Regular",
                    fontSize: 32,
                    color:colorScheme.primary,
                  ),
                  ),
                  const SizedBox(height: 32),

                  //Campo de Registar Ano de Nascimento
                  TextField(
                    controller: anoController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Ano de Nascimento (YYYY)",
                      hintStyle: TextStyle(color:colorScheme.primary,),
                    ),
                    style: TextStyle(color:colorScheme.primary,),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Altura
                  TextField(
                    controller: alturaController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Altura (cm)",
                      hintStyle: TextStyle(color:colorScheme.primary,),
                    ),
                    style: TextStyle(color:colorScheme.primary,),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Peso
                  TextField(
                    controller: pesoController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r"^\d{0,3}(\.\d{0,2})?$"))
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Peso (kg)",
                      hintStyle: TextStyle(color:colorScheme.primary,),
                    ),
                    style: TextStyle(color:colorScheme.primary,),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Género
                  TextField(
                    onTap: () => escolherGenero(context:context, controller:generoController),
                    controller: generoController, 
                    showCursor: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Género",
                      hintStyle: TextStyle(color:colorScheme.primary,),
                    ),
                    style: TextStyle(color:colorScheme.primary,),
                  ),                  
                  const SizedBox(height: 32),

                  //Botão Finalizar Registo Utilizador
                  FloatingActionButton(
                    heroTag: "finalizar_registo_conta",
                    onPressed: () async {
                      print("Finalizar Registo Utilizador pressionado!");
                      await finalizarRegisto();
                    },
                    foregroundColor: colorScheme.primary,
                    backgroundColor: colorScheme.secondary,
                    child: const Icon(Icons.create_outlined),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
    @override
    void dispose() {
      anoController.dispose();
      alturaController.dispose();
      pesoController.dispose();
      generoController.dispose();
      super.dispose();
    }   
  }

