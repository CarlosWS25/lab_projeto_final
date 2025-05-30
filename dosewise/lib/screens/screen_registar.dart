import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:dosewise/screens/screen_endregistar.dart";
import "package:dosewise/veri_device.dart";


class RegistarScreen extends StatefulWidget {
  const RegistarScreen({super.key});

  @override
  State<RegistarScreen> createState() => RegistarScreenState();
}

class RegistarScreenState extends State<RegistarScreen> {
  //Capturadores dos dados dos TextFields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPasswordController = TextEditingController();

Future<void> fazerRegisto() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    final confirmarPassword = confirmarPasswordController.text;

    if (username.isEmpty || password.isEmpty || confirmarPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    if (password != confirmarPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As palavras-passe não coincidem.")),
      );
      return;
    }

    final uri = await makeApiUri("/users/");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Conta criada com sucesso!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar conta: ${response.statusCode}")),
        );
      }
    } 
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro na requisição: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C4E2),
      body: Stack(
        children: [
  //Logo Dosewise
          Positioned(
            top: 50,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/images/logo_dosewise.png",
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
                  const SizedBox(height: 32),
                  Text("Registar",
                    style: TextStyle(
                      fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
                      fontSize: 32,
                      color:Color(0xFF1B3568),
                    ),
                  ),
                  const SizedBox(height: 32),
//Campo de Registar Username
                  TextField(
                    controller: usernameController,
                    showCursor: false,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Username",
                    ),
                  ),
                  const SizedBox(height: 16),
//Campo de Registar Password
                  TextField(
                    controller: passwordController,
                    showCursor: false,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 16),
//Campo de Registar Confirmar Password
                  TextField(
                    controller: confirmarPasswordController,
                    showCursor: false,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Confirmar Password",
                    ),
                  ),
                  const SizedBox(height: 32),
//Botão Registar Utilizador
                  FloatingActionButton(
                    heroTag: "registar_utilizador_conta",
                    onPressed: () async {
                      print("Registar Utilizador pressionado!");
                      final uri = await makeApiUri('/utilizador/registar');
                      //await fazerRegisto();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenEndRegistar()),
                      );
                      
                    },
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Icon(Icons.create),
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
  usernameController.dispose();
  passwordController.dispose();
  confirmarPasswordController.dispose();
  super.dispose();
}
}