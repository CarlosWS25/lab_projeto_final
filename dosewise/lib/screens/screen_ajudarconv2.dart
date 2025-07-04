import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/opcoes_gdu.dart";
import 'package:dosewise/screens/screen_endajudarconv.dart';

class ScreenAjudarConv2 extends StatefulWidget {
  final String ano;
  final String altura;
  final String peso;
  final String genero;
  final String doenca_pre_existente;

  const ScreenAjudarConv2({
    super.key,
    required this.ano,
    required this.altura,
    required this.peso,
    required this.genero,
    required this.doenca_pre_existente,
  });

  @override
  State<ScreenAjudarConv2> createState() => ScreenAjudarConv2State();
}

class ScreenAjudarConv2State extends State<ScreenAjudarConv2> {
  final TextEditingController usoController = TextEditingController();
  final TextEditingController sintomasController = TextEditingController();
  final TextEditingController doseController = TextEditingController();

  void ajudarConv2() {
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
          builder: (context) => ScreenEndAjudarConv(
            ano: widget.ano,
            altura: widget.altura,
            peso: widget.peso,
            genero: widget.genero,
            doenca_pre_existente: widget.doenca_pre_existente,
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
                      ajudarConv2();
                      print("Botão Ajudar utilizador pressionado!");
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
}