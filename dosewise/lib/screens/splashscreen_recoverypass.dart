import 'package:dosewise/screens/home_screen.dart';
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
        MaterialPageRoute(builder: (context) => const HomeScreen(),
        ),
      );
    });
  }
@override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
                fontSize: 30,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              widget.recoveryKey,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Guarde este número de recuperação\n para caso perca a sua password.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: 16,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
