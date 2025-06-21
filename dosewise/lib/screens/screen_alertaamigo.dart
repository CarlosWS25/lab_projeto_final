import "package:flutter/material.dart";

class ScreenAlertaAmigo extends StatelessWidget {
  const ScreenAlertaAmigo({super.key});

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
                  const SizedBox(height: 64),

//Título Adicionar Amigo
                  Text("Adicionar Amigo",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: 32,
                      color:colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

//Campo Nome do Amigo
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Nome do Amigo",
                    ),
                  ),
                  const SizedBox(height: 16),

//Campo Número do Amigo
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Número do Amigo",
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

//Botão Adicionar Amigo
                      FloatingActionButton(
                        heroTag: "botao_adicionar_amigo",
                        onPressed: () {
                          print("Botão Adicionar Amigo pressionado!");
                        },
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.person_add),
                      ),
                      const SizedBox(width: 235),

//Botão Remover Amigo
                      FloatingActionButton(
                        heroTag: "botao_remover_amigo",
                        onPressed: () {
                          print("Botão Remover Amigo pressionado!");
                        },
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.person_remove),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: SizedBox(
                      width: 125,
                      height: 125,

//Botão Alertar Amigos
                    child:FloatingActionButton(
                        heroTag: "botao_alertar_amigos",
                        onPressed: () {
                          print("Botão Alertar Amigos pressionado!");
                        },
                        backgroundColor: colorScheme.primary,
                        child: Text("Alertar\nAmigo",
                          style: TextStyle(
                            fontFamily: "Roboto-Regular",
                            fontSize: 25,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                    ),
                    ),
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