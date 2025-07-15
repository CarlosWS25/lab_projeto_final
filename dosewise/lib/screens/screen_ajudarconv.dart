import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/opcoes_gdus.dart";
import "package:dosewise/screens/screen_ajudarconv2.dart";

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
  final TextEditingController doenca_pre_existenteController = TextEditingController();

List<String> opcoesdoenca_pre_existente = [];

  @override
  void initState() {
    super.initState();
    carregarDoenca().then((value) {
      setState(() => opcoesdoenca_pre_existente = value);
    });
  }

  void iniciarRegistoConvidado(){
    final ano = anoController.text.trim();
    final altura = alturaController.text.trim();
    final peso = pesoController.text.trim();
    final genero = generoController.text.trim();
    final doenca_pre_existente = doenca_pre_existenteController.text.trim();

    if (ano.isEmpty || altura.isEmpty || peso.isEmpty || genero.isEmpty || doenca_pre_existente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenAjudarConv2(
          ano: ano,
          altura: altura,
          peso: peso,
          genero: genero,
          doenca_pre_existente: doenca_pre_existente,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          // Logo Dosewise
          Positioned(
            top: size.height * 0.05,
            right: size.width * 0.05,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.08),
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
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.14),

                  Text(
                    "Preencha os\ncampos abaixo",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.08,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Ano de nascimento
                  TextField(
                    controller: anoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Ano de Nascimento (YYYY)",
                      hintStyle: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: "Roboto-Regular",
                      ),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                      fontFamily: "Roboto-Regular",
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Altura
                  TextField(
                    controller: alturaController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Altura (cm)",
                      hintStyle: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: "Roboto-Regular",
                        ),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                      fontFamily: "Roboto-Regular",
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Peso
                  TextField(
                    controller: pesoController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r"^\d{0,3}(\.\d{0,2})?$"))
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Peso (kg)",
                      hintStyle: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: "Roboto-Regular",
                        ),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                      fontFamily: "Roboto-Regular",
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Género
                  TextField(
                    onTap: () => escolherGenero(context: context, controller: generoController),
                    controller: generoController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Género",
                      hintStyle: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: "Roboto-Regular",
                        ),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                      fontFamily: "Roboto-Regular",
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Doenças prévias
                  TextField(
                    onTap: () => escolherDoenca(context: context, controller: doenca_pre_existenteController, opcoes: opcoesdoenca_pre_existente),
                    controller: doenca_pre_existenteController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Doenças prévias",
                      hintStyle: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: "Roboto-Regular",
                        ),
                      contentPadding: EdgeInsets.all(size.width * 0.04),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                      fontFamily: "Roboto-Regular",
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Botão inciar registo convidado
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FloatingActionButton.extended(
                          onPressed: () {
                            print("Botão Iniciar Registo Convidado pressionado!");
                            iniciarRegistoConvidado();
                          },
                          backgroundColor: colorScheme.primary,
                          label: Text(
                            "Continuar",
                            style: TextStyle(
                              fontFamily: "Roboto-Regular",
                              color: colorScheme.onPrimary,
                              fontSize: size.width * 0.05,
                            ),
                          )
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
    anoController.dispose();
    alturaController.dispose();
    pesoController.dispose();
    generoController.dispose();
    doenca_pre_existenteController.dispose();
    super.dispose();
  }
}
