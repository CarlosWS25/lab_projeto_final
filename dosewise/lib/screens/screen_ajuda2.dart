import 'package:flutter/material.dart';
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
  final TextEditingController sintomasController = TextEditingController();

  Future<void> continuarAjuda() async {
    final sintomas = sintomasController.text.trim();

    if (sintomas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha o campo de sintomas.")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenEndAjuda(
          uso: widget.uso,
          dose: widget.dose,
          sintomas: sintomas,
        ),
      ),
    );
  }

  @override
  void dispose() {
    sintomasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          // Logo
          Positioned(
            top: size.height * 0.06,
            right: size.width * 0.05,
            child: Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
              width: size.width * 0.30,
              height: size.width * 0.30,
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

                  // Título
                  Text(
                    "Preencha o sintoma",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.07,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Campo Sintomas
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

                  // Botão avançar
                  Align(
                    alignment: Alignment.centerRight,
                    child: FloatingActionButton(
                      heroTag: "continuar_ajuda",
                      onPressed: continuarAjuda,
                      foregroundColor: colorScheme.primary,
                      backgroundColor: colorScheme.secondary,
                      child: Icon(
                        Icons.arrow_forward,
                        size: size.width * 0.09,
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
