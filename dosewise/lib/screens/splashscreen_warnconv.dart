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
      Future.delayed(const Duration(seconds: 5), () {
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
                """Todos os dados pessoais inseridos nesta aplicação são processados exclusivamente para efeitos de cálculo da pontuação de risco e recomendação de ações adequadas.
                
Estes dados são tratados localmente, não sendo armazenados, transferidos, ou partilhados com terceiros, em total conformidade com o Regulamento Geral sobre a Proteção de Dados (RGPD).                 
                
Esta abordagem garante a confidencialidade e privacidade dos utilizadores, contribuindo para uma utilização segura e responsável da aplicação.""",  
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
