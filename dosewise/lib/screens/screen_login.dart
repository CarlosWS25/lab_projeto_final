import "dart:convert";
import "dart:io";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:dosewise/screens/home_screen.dart";
import "package:dosewise/veri_device.dart";

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => ScreenLoginState();
}

class ScreenLoginState extends State<ScreenLogin> {
  //Capturadores dos dados dos TextFields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> fazerLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    final uri = await makeApiUri("/login");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text,
        }),
      );

    if (response.statusCode == 200) {
      print("Login bem-sucedido!");
      ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Login bem-sucedido!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
    } else {
      print("Falha no login: ${response.statusCode}");
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Falha no login: ${response.statusCode}")),
      );
    }
    } 
      catch (e) {
      print("Erro na requisição: $e");
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Login",
                    style: TextStyle(
                      fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
                      fontSize: 32,
                      color:Color(0xFF1B3568),
                    ),
                  ),
                  const SizedBox(height: 32),
//Campo Username de Login
                  TextField(
                    showCursor: false,
                    controller: usernameController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Username",
                    ),
                  ),
                  const SizedBox(height: 16),
//Campo Password de Login
                  TextField(
                    showCursor: false,
                    controller: passwordController,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 32),
//Botão Entrar na Conta
                  FloatingActionButton(
                    heroTag: "botao_entrar_conta",
                    onPressed: () async {
                      print("Botão Entrar pressionado!");
                      final uri = await makeApiUri('/utilizador/registar');
                      await fazerLogin();
                      
                    },
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Icon(Icons.login),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
//Garante que o controlador será removido da memória 
//quando a tela for fechada, evitando vazamentos de memória

@override
void dispose() {
  usernameController.dispose();
  passwordController.dispose();
  super.dispose();
}
}

