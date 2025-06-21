import "package:flutter/material.dart";

class PageGuia extends StatelessWidget {
  const PageGuia({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme; 

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: colorScheme.primary,
                ),
                children: [
                  TextSpan(
                    text: "Guia sobre Uso Responsável de Drogas e Álcool e Como Agir em Caso de Excessos\n\n",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "Introdução\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nO consumo recreativo de drogas e álcool é frequente em várias situações sociais. No entanto, é crucial conhecer limites, efeitos específicos das substâncias e os riscos associados para prevenir incidentes perigosos.\n\n"
                        "────────────────────────────────\n\n"
                  ),
                  TextSpan(
                    text: "Recomendações Gerais para um Consumo Seguro:\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\n• Informe-se previamente sobre os efeitos específicos da substância.\n"
                        "• Evite misturar substâncias sem conhecer possíveis interações.\n"
                        "• Alimente-se e hidrate-se adequadamente antes e durante o consumo.\n"
                        "• Certifique-se de estar acompanhado por pessoas de confiança.\n\n"
                        "────────────────────────────────\n\n",
                  ),
                  TextSpan(
                    text: "Efeitos Comuns de Drogas Recreativas:\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\n• Álcool: Relaxamento, diminuição da inibição, tonturas e, em quantidades elevadas, risco de intoxicação grave.\n"
                        "• Cannabis (erva, haxixe): Relaxamento, euforia, alteração da perceção do tempo e espaço, aumento do apetite, ansiedade em doses elevadas.\n"
                        "• MDMA (Ecstasy): Euforia, aumento de energia e empatia, dilatação das pupilas, risco de hipertermia (temperatura corporal elevada).\n"
                        "• Cocaína: Estimulação intensa, euforia, aumento do estado de alerta, ansiedade, risco cardíaco elevado em doses altas.\n"
                        "• LSD e psicadélicos semelhantes: Alucinações visuais e auditivas, alterações profundas da perceção, possibilidade de ansiedade ou pânico.\n\n"
                        "────────────────────────────────\n\n",
                  ),
                  TextSpan(
                    text: "Sinais de Alerta em Caso de Consumo Excessivo:\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nReconheça rapidamente sinais que indicam excesso:\n"
                        "• Confusão mental ou desorientação\n"
                        "• Vómitos repetidos\n"
                        "• Perda de consciência\n"
                        "• Respiração lenta ou irregular\n"
                        "• Pele fria e húmida\n\n"
                        "────────────────────────────────\n\n",
                  ),
                  TextSpan(
                    text: "Como Agir em Caso de Excesso:\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\n1. Avaliação inicial:\n"
                        "   • Tente comunicar com a pessoa para verificar a clareza de resposta.\n"
                        "   • Verifique sinais vitais básicos (respiração, pulso).\n\n"
                        "2. Posicionamento adequado:\n"
                        "   • Coloque a pessoa na posição lateral de segurança para evitar sufocação em caso de vómito.\n\n"
                        "3. Solicite ajuda imediata:\n"
                        "   • Contacte imediatamente os serviços de emergência (112).\n\n"
                        "4. Cuidados até chegada de auxílio:\n"
                        "   • Não abandone a pessoa.\n"
                        "   • Mantenha-a aquecida.\n"
                        "   • Evite induzir vómitos ou fornecer bebidas estimulantes.\n\n"
                        "────────────────────────────────\n\n",
                  ),
                  TextSpan(
                    text: "Prevenção e Educação:\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nA informação é essencial na prevenção. Converse abertamente sobre riscos, dosagens seguras e as consequências do consumo excessivo.\n\n"
                        "────────────────────────────────\n\n",
                  ),
                  TextSpan(
                    text: "Conclusão:\n",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "\nA responsabilidade e o conhecimento são essenciais para um consumo seguro e consciente. Em situações críticas, agir rapidamente pode salvar vidas.\n",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
