import "package:dosewise/screens/screen_inicial.dart";
import "package:flutter/material.dart";


class WarnScreen extends StatefulWidget {
  const WarnScreen({super.key});
  @override
  WarnScreenState createState() => WarnScreenState();
}

class WarnScreenState extends State<WarnScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenInicial()),
        );
      });
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFA7C4E2),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              """Esta aplicação tem fins exclusivamente informativos e educativos. Não substitui, em nenhuma circunstância, a avaliação, o diagnóstico ou o tratamento prestado por profissionais de saúde qualificados.

Em caso de emergência médica, contacta imediatamente os serviços de emergência (112) ou procura assistência médica profissional.

As recomendações fornecidas pela aplicação são baseadas em dados e critérios automatizados, podendo não refletir todas as variáveis clínicas específicas de cada caso individual.""",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF1B3568),
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