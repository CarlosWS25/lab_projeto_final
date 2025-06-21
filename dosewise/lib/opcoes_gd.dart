import "package:flutter/material.dart";

// Lista de Géneros
const List<String> opcoesGenero = ["Masculino", "Feminino"];
//Lista de Doenças

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