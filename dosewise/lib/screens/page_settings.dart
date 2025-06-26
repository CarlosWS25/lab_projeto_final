import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:dosewise/controlador_tema.dart";

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.03,
        ),
        child: ListView(
          children: [
            SizedBox(height: size.height * 0.04),

            Text(
              "Definições",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: size.width * 0.07, // fonte proporcional à largura da tela
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),

            SizedBox(height: size.height * 0.04),

            ListTile(
              title: Text(
                "Modo Escuro",
                style: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontSize: size.width * 0.045, // fonte proporcional
                  color: colorScheme.primary,
                ),
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
