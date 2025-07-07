import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:dosewise/controlador_tema.dart";
import "screens/splashscreen_load.dart";

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder(
      future: themeProvider.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,

        // Tema Claro personalizado
        theme: ThemeData(
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF1B3568),
            onPrimary: Color(0xFFA7C4E2),
            secondary: Color.fromARGB(255, 255, 255, 255),
            onSecondary: Color.fromARGB(255, 0, 0, 0),
            surface: Color.fromARGB(255, 255, 255, 255),
            onSurface: Color(0xFF1B3568),
            error: Colors.red,
            onError: Colors.white,
            
          ),
        ),

          // Tema Escuro personalizado
          darkTheme: ThemeData(
            colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: Color(0xFF1F1F1F),          // Fundo principal - cinza escuro elegante
            onPrimary: Color.fromARGB(255, 186, 186, 186),        // Texto sobre primary - branco suave
            secondary: Color.fromARGB(255, 255, 255, 255),        // Cor de destaque (verde água, moderna)
            onSecondary: Color(0xFF000000),      // Texto sobre secondary
            surface: Color(0xFF2C2C2C),          // Fundo de cards/inputs - cinza secundário
            onSurface: Color(0xFFE0E0E0),        // Texto sobre surface - branco suave
            error: Color(0xFFCF6679),            // Vermelho recomendado Material Design
            onError: Color(0xFF000000),          // Texto sobre erro
          ),
        ),
        home: ScreenLoad(),
        );
      },
    );
  }
}
