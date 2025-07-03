import "package:flutter/material.dart";
import "package:dosewise/screens/screen_endregistar.dart";

class ScreenRegistar extends StatefulWidget {
  const ScreenRegistar({super.key});

  @override
  State<ScreenRegistar> createState() => ScreenRegistarState();
}

class ScreenRegistarState extends State<ScreenRegistar> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPasswordController = TextEditingController();

  void iniciarRegisto(){
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmarPassword = confirmarPasswordController.text.trim();

    if (username.isEmpty || password.isEmpty || confirmarPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }
    if (password != confirmarPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("A password não coincide")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenEndRegistar(
          username: username,
          password: password,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          // Logo Dosewise
          Positioned(
            top: size.height * 0.06,
            right: size.width * 0.05,
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
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.04),

                  // Título Registar
                  Text(
                    "Create account",
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
                    showCursor: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Username",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary, fontSize: size.width * 0.045),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Campo Password
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
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary, fontSize: size.width * 0.045),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Campo Confirmar Password
                  TextField(
                    controller: confirmarPasswordController,
                    showCursor: false,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Confirmar Password",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary, fontSize: size.width * 0.045),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Botão Registar Utilizador com tamanho proporcional
                  SizedBox(
                    width: size.width * 0.15,
                    height: size.width * 0.15,
                    child: FloatingActionButton(
                      heroTag: "registar_utilizador_conta",
                      onPressed: () {
                        print("Botão Registar pressionado!");
                        iniciarRegisto();
                      },
                      foregroundColor: colorScheme.primary,
                      backgroundColor: colorScheme.secondary,
                      child: Icon(Icons.create_outlined, size: size.width * 0.08),
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
    confirmarPasswordController.dispose();
    super.dispose();
  }
}
