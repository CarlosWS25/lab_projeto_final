import "package:flutter/material.dart";

class ScreenAlertaAmigo extends StatelessWidget {
  const ScreenAlertaAmigo({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          // Logo Dosewise (tamanho relativo)
          Positioned(
            top: size.height * 0.1,
            right: size.width * 0.1,
            child: Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
              width: size.width * 0.25,
              height: size.width * 0.25,
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.1),

                  // Título
                  Text(
                    "Adicionar Amigo",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.08,
                      color: colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Campo Nome
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Nome do Amigo",
                      hintStyle: TextStyle(fontSize: size.width * 0.045),
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),

                  // Campo Número
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Número do Amigo",
                      hintStyle: TextStyle(fontSize: size.width * 0.045),
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // Botões Adicionar e Remover
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: "botao_adicionar_amigo",
                        onPressed: () {
                          print("Botão Adicionar Amigo pressionado!");
                        },
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.person_add),
                      ),
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

                  SizedBox(height: size.height * 0.05),

                  // Botão Alertar Amigo
                  Center(
                    child: SizedBox(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      child: FloatingActionButton(
                        heroTag: "botao_alertar_amigos",
                        onPressed: () {
                          print("Botão Alertar Amigos pressionado!");
                        },
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          "Alertar\nAmigo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Roboto-Regular",
                            fontSize: size.width * 0.05,
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
