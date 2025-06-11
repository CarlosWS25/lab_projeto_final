import "package:flutter/material.dart";

class ScreenAlarme extends StatelessWidget {
  const ScreenAlarme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFFA7C4E2),
      body: Center(
        child: Text(
          "Alarme aqui!",
        ),
      ),
    );
  }
}
