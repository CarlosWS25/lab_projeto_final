import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/opcoes_gdd.dart";

class ScreenAjudarConv extends StatefulWidget {
  const ScreenAjudarConv({super.key});

  @override
  State<ScreenAjudarConv> createState() => ScreenAjudarConvState();
}

class ScreenAjudarConvState extends State<ScreenAjudarConv> {
  final TextEditingController anoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
            top: size.height * 0.05,
            right: size.width * 0.05,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.light
                    ? "assets/images/logo_dosewise.png"
                    : "assets/images/logo_dosewise_dark.png",
                width: size.width * 0.25,
                height: size.width * 0.25,
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.08),

                  Text(
                    "Preencha com os dados \ndo convidado",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.07,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Ano de nascimento
                  TextField(
                    controller: anoController,
                    showCursor: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Ano de Nascimento (YYYY)",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // Altura
                  TextField(
                    controller: alturaController,
                    showCursor: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Altura (cm)",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // Peso
                  TextField(
                    controller: pesoController,
                    showCursor: false,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"^\d{0,3}(\.\d{0,2})?$"))
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Peso (kg)",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),

                  // Género
                  TextField(
                    onTap: () => escolherGenero(
                      context: context,
                      controller: generoController,
                    ),
                    controller: generoController,
                    showCursor: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Género",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Botão Finalizar
                  FloatingActionButton(
                    heroTag: "finalizar_registo_conta",
                    onPressed: () async {
                      print("Finalizar Registo Utilizador pressionado!");
                    },
                    foregroundColor: colorScheme.primary,
                    backgroundColor: colorScheme.secondary,
                    child: Icon(
                      Icons.create_outlined,
                      size: size.width * 0.07,
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
    anoController.dispose();
    alturaController.dispose();
    pesoController.dispose();
    generoController.dispose();
    super.dispose();
  }
}
