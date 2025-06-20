import "package:flutter/material.dart";
import "package:dosewise/screens/screen_ajuda.dart";
import "package:dosewise/screens/screen_ajudarconv.dart";
import "package:dosewise/screens/screen_sos.dart";
import "package:dosewise/screens/screen_alertaamigo.dart";
import "package:dosewise/screens/screen_warnconv.dart";




class PageMainMenu extends StatelessWidget {
  const PageMainMenu({super.key});

  //Frontend da página do menu principal
  @override
  Widget build(BuildContext context) {
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
              color:Color(0xFF1B3568),)
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
              backgroundColor: const Color(0xFF1B3568),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Ajudar",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: Color(0xFFA7C4E2),
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
                  MaterialPageRoute(builder: (context) => const WarnAjudarConv()),
                );
              },
              backgroundColor: const Color(0xFF1B3568),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("   Ajudar \nConvidado",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: Color(0xFFA7C4E2),
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
              backgroundColor: const Color(0xFF1B3568),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("SOS",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: Color(0xFFA7C4E2),
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
              backgroundColor: const Color(0xFF1B3568),
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("Alertar Amigo",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: Color(0xFFA7C4E2),
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