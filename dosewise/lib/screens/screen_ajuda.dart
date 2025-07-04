import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:dosewise/opcoes_gdu.dart";
import "package:dosewise/screens/screen_endajuda.dart";

class ScreenAjuda extends StatefulWidget {
  const ScreenAjuda({super.key});

  @override
  State<ScreenAjuda> createState() => ScreenAjudaState();
}

class ScreenAjudaState extends State<ScreenAjuda> {
  final TextEditingController usoController = TextEditingController();
  final TextEditingController doseController = TextEditingController();
  final TextEditingController sintomasController = TextEditingController();

  void iniciarAjuda() {
    final uso = usoController.text.trim();
    final dose = doseController.text.trim();
    final sintomas = sintomasController.text.trim();

    if (uso.isEmpty || dose.isEmpty || sintomas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenEndAjuda(
          uso: uso,
          dose: dose,
          sintomas: sintomas,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    carregarUso().then((value) {
      setState(() {
        opcoesUso = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          // Logo Dosewise com tamanho proporcional
          Positioned(
            top: size.height * 0.06,
            right: size.width * 0.05,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/images/logo_dosewise.png"
                    : "assets/images/logo_dosewise_dark.png",
                width: size.width * 0.3,
                height: size.width * 0.3,
              ),
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

                  // Título do Ajuda com tamanho relativo
                  Text(
                    "Preencha os seguintes campos",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.07,
                      color: colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Campo de Drogas
                  TextField(
                    onTap: () => escolherUso(
                        context: context,
                        controller: usoController,
                        opcoes: opcoesUso),
                    controller: usoController,
                    showCursor: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Drogas usadas",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary, fontSize: size.width * 0.05),
                  ),

                  SizedBox(height: size.height * 0.02),

                  // Campo de Dose em Gramas
                  TextField(
                    controller: doseController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^\d{0,3}(\.\d{0,1})?$"))
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Dose (g)",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary, fontSize: size.width * 0.05),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Campo dos Sintomas
                  TextField(
                    controller: sintomasController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Sintomas",
                      hintStyle: TextStyle(color: colorScheme.primary),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                        horizontal: size.width * 0.04,
                      ),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),

                  // Botão Começar Ajuda com tamanho proporcional
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: size.width * 0.18,
                      height: size.width * 0.18,
                    child: FloatingActionButton(
                      heroTag: "ajudar_utilizador",
                      onPressed: () {
                        print("Botão Ajudar utilizador pressionado!");
                        iniciarAjuda();
                      },
                      foregroundColor: colorScheme.primary,
                        backgroundColor: colorScheme.secondary,
                        child: Icon(
                          Icons.create_outlined,
                          size: size.width * 0.09,
                        ),
                      ),
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
    usoController.dispose();
    doseController.dispose();
    sintomasController.dispose();
    super.dispose();
  }
}

  