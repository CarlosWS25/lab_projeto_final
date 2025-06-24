import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Lista de Géneros
const List<String> opcoesGenero = ["Masculino", "Feminino"];
//Lista de Doenças
List<String> opcoesDoenca = [];
List<String> opcoesUso = [];


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
//Carregar drogas de ficheiro .txt
Future<List<String>> carregarUso() async {
  final String listaUso = await rootBundle.loadString("assets/txt/drogas.txt");
  return listaUso
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
              children: opcoes.map((String doencas) {
                return ListTile(
                  title: Text(doencas),
                  onTap: () {
                    controller.text = doencas;
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

// Caixa de texto que escolhe as uso
void escolherUso({
  required BuildContext context,
  required TextEditingController controller,
  required List<String> opcoes,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Selecione a droga consumida"),
        content: SizedBox(
          height: 250,
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: opcoes.map((String uso) {
                return ListTile(
                  title: Text(uso),
                  onTap: () {
                    controller.text = uso;
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