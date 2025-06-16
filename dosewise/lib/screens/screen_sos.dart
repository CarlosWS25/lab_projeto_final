import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';


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
        callNumber("+351966650501");
        print("✅ Botão pressionado por 5 segundos!");
      }
      );
    }
    );
  }
  void pressOFF(TapUpDetails details) {
    setState(() {
      isPressed = false;
    }
    );
    fiveSecPressed?.cancel();
  }
  
  void noMove() {
  setState(() {
    isPressed = false;
  }
  );
  fiveSecPressed?.cancel();
  }

  Future<void> callNumber(String number) async {
  PermissionStatus status = await Permission.phone.request();

  if (status.isGranted) {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      print('❌ Não foi possível lançar o marcador');
    }
  } else {
    print('❌ Permissão de chamada telefónica negada');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C4E2),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

//Texto de SOS
            const Text("CHAMAR 112",
              style: TextStyle(
                fontFamily: "Roboto-Regular",  
                fontWeight: FontWeight.bold,
                fontSize: 56,
                color:Color(0xFF1B3568),)
            ),
            const SizedBox(height: 32),

//Botão SOS
            GestureDetector(
          onTapDown: pressON,
          onTapUp: pressOFF,
          onTapCancel: noMove,
          child: Image.asset(
            isPressed
                ? "assets/images/button_on.png"
                : "assets/images/button_off.png",
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 32),

//Texto de informativo SOS
            const Text("Pressione o botão durante cerca de\n   5 segundos para chamar o 112",
              style: TextStyle(
                fontFamily: "Roboto-Regular",  
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color:Color(0xFF1B3568),)
            ),
            const SizedBox(height: 32),
        ]
      ),
      )
    );
  }
}
