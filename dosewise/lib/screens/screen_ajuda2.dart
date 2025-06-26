import 'package:flutter/material.dart';
import 'package:dosewise/opcoes_gdd.dart';
import 'package:dosewise/screens/screen_endajuda.dart';

class ScreenAjuda2 extends StatefulWidget {
  final String uso;
  final String dose;

  const ScreenAjuda2({
    super.key,
    required this.uso,
    required this.dose,
  });

  @override
  State<ScreenAjuda2> createState() => ScreenAjuda2State();
}

class ScreenAjuda2State extends State<ScreenAjuda2> {
  final TextEditingController doencasController = TextEditingController();
  final TextEditingController sintomasController = TextEditingController();

  Future<void> continuarAjuda() async {
    final doencas = doencasController.text.trim();
    final sintomas = sintomasController.text.trim();

    if (doencas.isEmpty || sintomas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenEndAjuda(
          uso: widget.uso,
          dose: widget.dose,
          doencas: doencas,
          sintomas: sintomas,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    carregarDoencas().then((value) {
      setState(() {
        opcoesDoenca = value;
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
          // Logo Dosewise com tamanho relativo
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

                  // Título responsivo
                  Text(
                    "Preencha os seguintes campos",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.07,
                      color: colorScheme.primary,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  // Campo Doenças
                  TextField(
                    onTap: () => escolherDoenca(
                      context: context,
                      controller: doencasController,
                      opcoes: opcoesDoenca,
                    ),
                    controller: doencasController,
                    showCursor: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Doenças prévias",
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

                  SizedBox(height: size.height * 0.025),

                  // Campo Sintomas
                  TextField(
                    controller: sintomasController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
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

                  // Botão flutuante maior e posicionado para direita
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: size.width * 0.18,
                      height: size.width * 0.18,
                      child: FloatingActionButton(
                        heroTag: "finalizar_ajuda_utilizador",
                        onPressed: () async {
                          print("Botão Finalizar Ajudar pressionado!");
                          continuarAjuda();
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
    doencasController.dispose();
    sintomasController.dispose();
    super.dispose();
  }
}

