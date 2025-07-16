import 'package:flutter/material.dart';
import 'package:dosewise/screens/screen_ajuda.dart';
import 'package:dosewise/screens/screen_sos.dart';
import 'package:dosewise/screens/screen_alertaamigo.dart';
import 'package:dosewise/screens/splashscreen_warnconv.dart';

class PageMainMenu extends StatelessWidget {
  const PageMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.15),

// Título Menu Principal
            Text(
              "Menu Principal",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.1,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: size.height * 0.1),

// Primeira linha de botões
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.35,
                  height: size.height * 0.12,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      print("Botão Ajudar pressionado!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenAjuda()),
                      );
                    },
                    backgroundColor: colorScheme.primary,
                    label: Text(
                      "Ajudar",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.onPrimary,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.05),

                SizedBox(width: size.width * 0.35, height: size.height * 0.12,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      print("Botão Ajudar Convidado pressionado!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenWarnAjudarConv()),
                      );
                    },
                    backgroundColor: colorScheme.primary,
                    label: Text(
                      "Ajudar\nConvidado",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.onPrimary,
                        fontSize: size.width * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: size.height * 0.1),

// Segunda linha de botões
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: size.width * 0.35, height: size.height * 0.12,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      print("Botão SOS pressionado!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenAlarme()),
                      );
                    },
                    backgroundColor: colorScheme.primary,
                    label: Text(
                      "SOS",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.onPrimary,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.05),
                SizedBox(width: size.width * 0.35, height: size.height * 0.12,
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      print("Botão Alerta Amigo pressionado!");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenAlertaAmigo()),
                      );
                    },
                    backgroundColor: colorScheme.primary,
                    label: Text(
                      "Alerta Amigos",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.onPrimary,
                        fontSize: size.width * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
