import "package:flutter/material.dart";
import "dart:async";
import "package:url_launcher/url_launcher.dart";
import "package:permission_handler/permission_handler.dart";

class ScreenAlarme extends StatefulWidget {
  const ScreenAlarme({super.key});

  @override
  State<ScreenAlarme> createState() => _ScreenAlarmeState();
}

class _ScreenAlarmeState extends State<ScreenAlarme> {
  bool isPressed = false;
  Timer? fiveSecPressed;
  DateTime? timeNow;

  void pressON(TapDownDetails details) {
    setState(() {
      isPressed = true;
      timeNow = DateTime.now();
      fiveSecPressed = Timer(const Duration(seconds: 5), () {
        callNumber("112");
        print("Botão pressionado por 5 segundos!");
      });
    });
  }

  void pressOFF(TapUpDetails details) {
    setState(() {
      isPressed = false;
    });
    fiveSecPressed?.cancel();
  }

  void noMove() {
    setState(() {
      isPressed = false;
    });
    fiveSecPressed?.cancel();
  }

  Future<void> callNumber(String number) async {
    PermissionStatus status = await Permission.phone.request();

    if (status.isGranted) {
      final Uri phoneUri = Uri(scheme: "tel", path: number);
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
      } else {
        print("Não foi possível lançar o marcador");
      }
    } else {
      print("Permissão de chamada telefónica negada");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Texto de SOS
            Text(
              "CHAMAR 112",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.14, // fonte relativa à largura
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: size.height * 0.04),

            // Botão SOS
            GestureDetector(
              onTapDown: pressON,
              onTapUp: pressOFF,
              onTapCancel: noMove,
              child: Image.asset(
                isPressed
                    ? "assets/images/button_on.png"
                    : "assets/images/button_off.png",
                width: size.width * 0.6,   // largura responsiva
                height: size.width * 0.6,  // mantém quadrado proporcional
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: size.height * 0.04),

            // Texto informativo SOS
            Text(
              "Pressione o botão durante cerca de\n   5 segundos para chamar o 112",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.04, // fonte proporcional
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}

