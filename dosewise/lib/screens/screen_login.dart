import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;
import "package:dosewise/screens/home_screen.dart";
import "package:dosewise/veri_device.dart";
import "package:shared_preferences/shared_preferences.dart";


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
      final body = jsonDecode(response.body);
      final token = body["access_token"];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);  
      print("Token guardado: $token");

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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

//Título da Tela de Login
                  Text("Login",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: 32,
                      color:colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

//Campo Username de Login
                  TextField(
                    controller: usernameController,
                    showCursor: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Username",
                      hintStyle: TextStyle(color:colorScheme.primary,),
                    ),
                    style: TextStyle(color:colorScheme.primary,),
                  ),
                  const SizedBox(height: 16),

//Campo Password de Login
                  TextField(
                    controller: passwordController,
                    showCursor: false,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Password",
                      hintStyle: TextStyle(color:colorScheme.primary,),
                    ),
                    style: TextStyle(color:colorScheme.primary,),
                  ),
                  const SizedBox(height: 32),

//Botão Entrar na Conta
                  FloatingActionButton(
                    heroTag: "botao_entrar_conta",
                    onPressed: () async {
                      print("Botão Entrar pressionado!");
                      //final uri = await makeApiUri("/utilizador/registar");
                      await fazerLogin(); 
                    },
                    foregroundColor: colorScheme.primary,
                    backgroundColor: colorScheme.secondary,
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

