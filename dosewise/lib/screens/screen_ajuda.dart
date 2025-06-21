import "package:flutter/material.dart";

class ScreenAjuda extends StatelessWidget {
  const ScreenAjuda({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; 
    return Scaffold(
    backgroundColor: colorScheme.onPrimary,
      body: Center(
        child: Text(
          "Ajuda aqui!",
        ),
      ),
    );
  }
}
