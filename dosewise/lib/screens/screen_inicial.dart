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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = constraints.maxHeight;

            return Column(
              children: [
                SizedBox(height: screenHeight * 0.15),
                // Logo
                Center(
                  child: Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? "assets/images/logo_dosewise.png"
                        : "assets/images/logo_dosewise_dark.png",
                    width: size.width * 0.4,
                    height: size.height * 0.2,
                    fit: BoxFit.contain,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Título
                Text(
                  "Dosewise",
                  style: TextStyle(
                    fontFamily: "Roboto-Regular",
                    fontWeight: FontWeight.bold,
                    fontSize: size.width * 0.1,
                    color: colorScheme.primary,
                  ),
                ),

                SizedBox(height: screenHeight * 0.15),

                // Botão Login
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FloatingActionButton.extended(
                      heroTag: "login_perfil",
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
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Botão Registar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FloatingActionButton.extended(
                      heroTag: "registar_perfil",
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
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.08),
              ],
            );
          },
        ),
      ),
    );
  }
}
