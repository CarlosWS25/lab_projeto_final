import "package:flutter/material.dart";
import "package:dosewise/screens/screen_ajuda.dart";
import "package:dosewise/screens/screen_sos.dart";
import "package:dosewise/screens/screen_alertaamigo.dart";
import "package:dosewise/screens/splashscreen_warnconv.dart";

class PageMainMenu extends StatelessWidget {
  const PageMainMenu({super.key});

  //Frontend da página do menu principal
  @override
  Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;  

    return Stack(
      children: [
        Positioned(
          bottom: 575,
          right: 40,
          child: Text("Menu Principal",
            style: TextStyle(
              fontFamily: "Roboto-Regular",  
              fontWeight: FontWeight.bold,
              fontSize: 50,
              color: colorScheme.primary,
            )
          ),
        ),
        
// Botão Ajudar
        Positioned(
          bottom: 400,
          right: 225,
          child: SizedBox(
            width: 150,
            height: 100,
            child: FloatingActionButton.extended(
              heroTag: "ajudar",
              onPressed: () {
                print("Botão Ajudar pressionado!");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenAjuda()),
                );
              },
              backgroundColor: colorScheme.primary,
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Ajudar",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

// Botão Ajudar Convidado
        Positioned(
          bottom: 400,
          right: 50,
          child: SizedBox(
            width: 150,
            height: 100,
            child: FloatingActionButton.extended(
              heroTag: "ajudar_convidado",
              onPressed: () {
                print("Botão Ajudar Convidado pressionado!");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenWarnAjudarConv()),
                );
              },
              backgroundColor: colorScheme.primary,
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("   Ajudar \nConvidado",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

// Botão Alarme
        Positioned(
          bottom: 250,
          right: 225,
          child: SizedBox(
            width: 150,
            height: 100,
            child: FloatingActionButton.extended(
              heroTag: "sos",
              onPressed: () {
                print("Botão SOS pressionado!");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenAlarme()),
                );
              },
              backgroundColor: colorScheme.primary,
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("SOS",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),

// Botão Alerta Amigo
        Positioned(
          bottom: 250,
          right: 50,
          child: SizedBox(
            width: 150,
            height: 100,
            child: FloatingActionButton.extended(
              heroTag: "alerta_amigo",
              onPressed: () {
                print("Botão Alerta Amigo pressionado!");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ScreenAlertaAmigo()),
                );
              },
              backgroundColor: colorScheme.primary,
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Alertar Amigo",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: colorScheme.onPrimary,
                      fontSize: 20,
                  ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}