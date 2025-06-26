import 'package:dosewise/screens/screen_ajudarconv.dart';
import 'package:flutter/material.dart';

class ScreenWarnAjudarConv extends StatefulWidget {
  const ScreenWarnAjudarConv({super.key});
  @override
  ScreenWarnAjudarConvState createState() => ScreenWarnAjudarConvState();
}

class ScreenWarnAjudarConvState extends State<ScreenWarnAjudarConv> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenAjudarConv()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Ainda não sei o texto",  // Atualiza aqui o texto que quiseres
                style: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.045,
                  height: 1.5,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: size.height * 0.02),
              // Aqui podes adicionar outros widgets se quiseres
            ],
          ),
        ),
      ),
    );
  }
}
