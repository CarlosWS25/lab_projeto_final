import "package:flutter/material.dart";
import "package:dosewise/screens/screen_login.dart";
import "package:dosewise/screens/screen_registar.dart";

class ScreenInicial extends StatelessWidget {
  const ScreenInicial({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: SafeArea(
        child: Column(
          children: [

// Logo Dosewise
            SizedBox(height: size.height * 0.15),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? "assets/images/logo_dosewise.png"
                        : "assets/images/logo_dosewise_dark.png",
                    width: size.width * 0.4,
                    height: size.height * 0.2,
                  ),
                  SizedBox(height: size.height * 0.02),

// Título Dosewise
                  Text(
                    "Dosewise",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontWeight: FontWeight.bold,
                      fontSize: size.width * 0.1,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.18),

// Botão Login
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScreenLogin()),
                    );
                  },
                  backgroundColor: colorScheme.primary,
                  label: Text(
                    "Login",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: colorScheme.onPrimary,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.04),

// Botão Criar Conta
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScreenRegistar()),
                    );
                  },
                  backgroundColor: colorScheme.primary,
                  label: Text(
                    "Criar conta",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      color: colorScheme.onPrimary,
                      fontSize: size.width * 0.05,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.08),
          ],
        ),
      ),
    );
  }
}
