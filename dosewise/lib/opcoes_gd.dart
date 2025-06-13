import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Lista de Géneros
const List<String> opcoesGenero = ["Masculino", "Feminino"];
//Lista de Doenças
 List<String> opcoesDoenca = [];

//Transforma o género num formato compatível com a base de dados
final Map<String, String> mapGenero = {
    "Masculino": "M",
    "Feminino": "F",
    };


// Caixa de texto que escolhe o género
void escolherGenero({
  required BuildContext context,
  required TextEditingController controller,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Selecione o seu género"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: opcoesGenero.map((String genero) {
            return ListTile(
              title: Text(genero),
              onTap: () {
                controller.text = genero;
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      );
    },
  );
}

// Carrega doenças de ficheiro .txt
Future<List<String>> carregarDoencas() async {
  final String listaDoencas = await rootBundle.loadString("assets/txt/doencas.txt");
  return listaDoencas
      .split("\n")
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

// Caixa de texto que escolhe as doenças
void escolherDoenca({
  required BuildContext context,
  required TextEditingController controller,
  required List<String> opcoes,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Selecione as suas doenças"),
        content: SizedBox(
          height: 250,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: opcoes.map((String doenca) {
                return ListTile(
                  title: Text(doenca),
                  onTap: () {
                    controller.text = doenca;
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      );
    },
  );
}


