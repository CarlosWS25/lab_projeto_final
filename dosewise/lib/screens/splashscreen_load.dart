import "package:flutter/material.dart";
import "splashscreen_warn.dart";
import 'dart:async';

class ScreenLoad extends StatefulWidget {
  const ScreenLoad({super.key});
  @override
  ScreenLoadState createState() => ScreenLoadState();
}

class ScreenLoadState extends State<ScreenLoad> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScreenWarn()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
              width: size.width * 0.25,   // 25% da largura da tela
              height: size.width * 0.25,  // manter proporção quadrada
              fit: BoxFit.contain,
            ),
            SizedBox(height: size.height * 0.01),

            Text(
              "dosewise",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.12,  // fonte proporcional à largura
                letterSpacing: size.width * 0.015,
                color: colorScheme.primary,
              ),
            ),

            Text(
              "OVERDOSE PREVENTION APP",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: size.width * 0.05,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
