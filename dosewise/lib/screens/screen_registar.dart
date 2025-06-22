import "package:flutter/material.dart";
import "package:dosewise/screens/screen_endregistar.dart";


class ScreenRegistar extends StatefulWidget {
  const ScreenRegistar({super.key});

  @override
  State<ScreenRegistar> createState() => ScreenRegistarState();
}

class ScreenRegistarState extends State<ScreenRegistar> {
  //Controllers que capturam os dados dos TextFields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPasswordController = TextEditingController();


  //Função que inicia o registo do utilizador
  void iniciarRegisto(){
  final username = usernameController.text.trim();
  final password = passwordController.text.trim();
  final confirmarPassword = confirmarPasswordController.text.trim();

  //Validação dos campos
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
                  const SizedBox(height: 32),

                  //Título Registar
                  Text("Create account",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: 32,
                      color:colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  //Campo de Registar Username
                  TextField(
                    controller: usernameController,
                    showCursor: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Username",
                      hintStyle: TextStyle(color:colorScheme.primary),
                    ),
                    style: TextStyle(color:colorScheme.primary),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Password
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
                      hintStyle: TextStyle(color:colorScheme.primary),
                    ),
                    style: TextStyle(color:colorScheme.primary),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Confirmar Password
                  TextField(
                    controller: confirmarPasswordController,
                    showCursor: false,
                    obscureText: true,
                    obscuringCharacter: "*",
                    decoration:InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Confirmar Password",
                      hintStyle: TextStyle(color:colorScheme.primary),
                    ),
                    style: TextStyle(color:colorScheme.primary),
                  ),
                  const SizedBox(height: 32),
                  
                  //Botão Registar Utilizador
                  FloatingActionButton(
                    heroTag: "registar_utilizador_conta",
                    onPressed: () async {
                      print("Botão Registar pressionado!");
                      iniciarRegisto();
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
    usernameController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();
    super.dispose();
  }
}
