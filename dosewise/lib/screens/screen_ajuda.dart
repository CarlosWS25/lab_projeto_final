import "package:flutter/material.dart";

class ScreenAjuda extends StatelessWidget {
  const ScreenAjuda({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color(0xFFA7C4E2),
      body: Center(
        child: Text(
          "Ajuda aqui!",
        ),
      ),
    );
  }
}
