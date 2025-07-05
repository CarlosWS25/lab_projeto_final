import "dart:convert";
import "package:dosewise/screens/screen_alterarpassword.dart";
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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> fazerLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

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
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final token = body["access_token"];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);
        print("Token guardado: $token");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login bem-sucedido!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Falha no login: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Erro na requisição: $e");
    }
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

// Título do Login
                  Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.08,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

// Campo Username
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Username",
                      hintStyle: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.primary
                      ),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  SizedBox(height: size.height * 0.02),

// Campo Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Password",
                      hintStyle: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.primary
                      ),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  SizedBox(height: size.height * 0.04),

// Botão Inciar sessão
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () async {
                            print("Botão Iniciar sessão pressionado!");
                            await fazerLogin();
                          },
                          backgroundColor: colorScheme.primary,
                          label: Text(
                            "Iniciar sessão",
                            style: TextStyle(
                              fontFamily: "Roboto-Regular",
                              color: colorScheme.onPrimary,
                              fontSize: size.width * 0.05,
                            ),
                          )
                        ),
                        SizedBox(height: size.height * 0.02),

//Botão Recuperar Password
                        FloatingActionButton.extended(
                          onPressed: () {
                            print("Botão Recuperar Password pressionado!");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const ScreenAlterarPassword()),
                            );
                          },
                          backgroundColor: colorScheme.primary,
                          label: Text(
                            "Esqueci-me da password",
                            style: TextStyle(
                              fontFamily: "Roboto-Regular",
                              color: colorScheme.onPrimary,
                              fontSize: size.width * 0.05,
                            ),
                          ),
                        ),
                      ],
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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

