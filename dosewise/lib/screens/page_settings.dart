import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:dosewise/controlador_tema.dart"; // onde está o ThemeProvider

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme; 

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 32),

            Text("  Definições",
            style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary),
              ),
            const SizedBox(height: 32),

            ListTile(
              title: Text("Modo Escuro",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: 16,
                color: colorScheme.primary),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

