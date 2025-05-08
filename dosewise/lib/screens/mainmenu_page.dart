import "package:flutter/material.dart";
import "package:dosewise/screens/ajuda_screen.dart";
import "package:dosewise/screens/ajudaconv_screen.dart";
import "package:dosewise/screens/alarme_screen.dart";
import "package:dosewise/screens/alertamigo_screen.dart";



class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 575,
          right: 85,
        child: Text("Main Menu",
          style: TextStyle(
            fontFamily: "Fontspring-DEMO-clarikaprogeo-md",  
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
              MaterialPageRoute(builder: (context) => const ajuda_screen()),
            );
          },
        backgroundColor: const Color(0xFF1B3568),
        label: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Ajudar",
              style: TextStyle(
                fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
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
              MaterialPageRoute(builder: (context) => const ajudaconv_screen()),
            );
          },
        backgroundColor: const Color(0xFF1B3568),
        label: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("    Ajudar \n Convidado",
              style: TextStyle(
                fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
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
          heroTag: "alarme",
          onPressed: () {
            print("Botão Alarme pressionado!");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const alarme_screen()),
            );
          },
        backgroundColor: const Color(0xFF1B3568),
        label: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Alarme",
              style: TextStyle(
                fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
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
              MaterialPageRoute(builder: (context) => const alertamigo_screen()),
            );
          },
        backgroundColor: const Color(0xFF1B3568),
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Alerta Amigo",
                style: TextStyle(
                  fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
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