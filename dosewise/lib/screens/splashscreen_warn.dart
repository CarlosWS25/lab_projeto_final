import "package:dosewise/screens/screen_inicial.dart";
import "package:flutter/material.dart";


class ScreenWarn extends StatefulWidget {
  const ScreenWarn({super.key});
  @override
  ScreenWarnState createState() => ScreenWarnState();
}

class ScreenWarnState extends State<ScreenWarn> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenInicial()),
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
                """Esta aplicação tem fins exclusivamente informativos e educativos. Não substitui, em nenhuma circunstância, a avaliação, o diagnóstico ou o tratamento prestado por profissionais de saúde qualificados.

Em caso de emergência médica, contacta imediatamente os serviços de emergência (112) ou procura assistência médica profissional.

As recomendações fornecidas pela aplicação são baseadas em dados e critérios automatizados, podendo não refletir todas as variáveis clínicas específicas de cada caso individual.""",
                style: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * 0.04,
                  height: 1.5,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
