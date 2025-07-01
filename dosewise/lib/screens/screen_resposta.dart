import 'package:flutter/material.dart';
import 'package:dosewise/screens/home_screen.dart';

class ScreenResposta extends StatelessWidget {
  final Map<String, dynamic> resposta;

  const ScreenResposta({super.key, required this.resposta});

  @override
  Widget build(BuildContext context) {
    final double riskScore = resposta['risk_score']?.toDouble() ?? 0.0;
    final String substanciaAntagonista = resposta['substância_antagonista'] ?? 'Não aplicável';
    final String dica = resposta['dica'] ?? 'Nenhuma dica fornecida';

    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      appBar: AppBar(
        title: const Text('Resultado da Avaliação'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Risco de Overdose:',
              style: TextStyle(fontSize: size.width * 0.06, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              '$riskScore / 10',
              style: TextStyle(
                fontSize: size.width * 0.12,
                color: colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.04),
            Text(
              'Substância Antagonista:',
              style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              substanciaAntagonista,
              style: TextStyle(fontSize: size.width * 0.05, color: colorScheme.primary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.04),
            Text(
              'Dica:',
              style: TextStyle(fontSize: size.width * 0.05, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              dica,
              style: TextStyle(fontSize: size.width * 0.045),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.06),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: Size(size.width * 0.6, size.height * 0.06),
              ),
              child: Text(
                'Voltar ao Início',
                style: TextStyle(fontSize: size.width * 0.045),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
