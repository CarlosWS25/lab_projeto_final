import 'package:dosewise/screens/screen_inicial.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ScreenRecovery extends StatefulWidget {
  final String recoveryKey;

  const ScreenRecovery({super.key, required this.recoveryKey});

  @override
  State<ScreenRecovery> createState() => _ScreenRecoveryState();
}

class _ScreenRecoveryState extends State<ScreenRecovery> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ScreenInicial(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size; // pega o tamanho da tela

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Código de Recuperação",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.08, // fonte relativa à largura
                color: colorScheme.primary,
              ),
            ),

            SizedBox(height: size.height * 0.04),

            Text(
              widget.recoveryKey,
              style: TextStyle(
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),

            SizedBox(height: size.height * 0.04),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Text(
                "Guarde este número de recuperação\n para caso perca a sua password.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontSize: size.width * 0.045,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
