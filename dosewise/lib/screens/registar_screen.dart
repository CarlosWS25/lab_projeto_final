import "package:flutter/material.dart";

class Registar_screen extends StatelessWidget {
  const Registar_screen({super.key});

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
//Botão Criar Conta
                  FloatingActionButton(
                    heroTag: "botao_criar_conta",
                    onPressed: () {
                      print("Botão Criar Conta pressionado!");
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
}