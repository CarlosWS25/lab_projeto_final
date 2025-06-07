import "dart:convert";
import "dart:io";
import "package:http/http.dart" as http;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/screens/screen_profile.dart";
import "package:dosewise/veri_device.dart";

class ScreenEndRegistar extends StatefulWidget {
  final String username;
  final String password;

  const ScreenEndRegistar({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<ScreenEndRegistar> createState() => ScreenEndRegistarState();
}

class ScreenEndRegistarState extends State<ScreenEndRegistar> {
  //Capturadores dos dados dos TextFields
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController doencasController = TextEditingController();

//Função que completa o registo do utilzador
Future<void> finalizarRegisto() async {
    final altura = alturaController.text.trim();
    final peso = pesoController.text.trim();
    final ano = anoController.text.trim();
    final doencas = doencasController.text.trim();
    final genero = generoController.text.trim();

    if (altura.isEmpty || peso.isEmpty || ano.isEmpty || doencas.isEmpty || genero.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    final int? alturaInt = int.tryParse(altura);
    final double? pesoDouble = double.tryParse(peso);
    final int? anoNascimentoInt = int.tryParse(ano);

    final Map<String, String> mapGenero = {
    "Masculino": "M",
    "Feminino": "F",
};
    final generoEnviado = mapGenero[genero] ?? genero;

    final uri = await makeApiUri("/users/");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": widget.username,
          "password": widget.password,
          "ano_nascimento": anoNascimentoInt,
          "altura_cm": alturaInt,
          "peso": pesoDouble,
          "genero": generoEnviado,
          "doencas": doencas,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Conta criada com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenProfile()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao criar conta: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na requisição: $e")),
      );
    }
  }


  //Caixa de opções de género
  final List<String> opcoesGenero = ["Masculino", "Feminino"];
  void escolherGenero(BuildContext context, TextEditingController controller, List<String> opcoes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione o seu gênero'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: opcoesGenero.map((String genero) {
              return ListTile(
                title: Text(genero),
                onTap: () {
                  generoController.text = genero;
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }


  //Caixa de opções de doenças
  List<String> opcoesDoencas = [];
  @override
  void initState() {
    super.initState();
    carregarDoencas();
  }

  Future<void> carregarDoencas() async {
    final String listaDoencas = await rootBundle.loadString('assets/txt/doencas.txt');
    setState(() {
      opcoesDoencas = listaDoencas
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    });
  }

  void escolherDoencas(BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione a sua doença'),
          content: SizedBox(
            height: 250,
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: opcoesDoencas.map((String doenca) {
                  return ListTile(
                    title: Text(doenca),
                    onTap: () {
                      doencasController.text = doenca;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C4E2),
      body: Stack(
        children: [
          //Logo Dosewise
          Positioned(
            top: 50,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset("assets/images/logo_dosewise.png",
                width: 125,
                height: 125,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 64),
                  Text("Finalizar Registo",
                    style: TextStyle(
                      fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
                      fontSize: 32,
                      color:Color(0xFF1B3568),
                    ),
                  ),
                  const SizedBox(height: 32),

                  //Campo de Registar Altura
                  TextField(
                    controller: alturaController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Altura (cm)",
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Ano de Nascimento
                  TextField(
                    controller: anoController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Ano de Nascimento",
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Peso
                  TextField(
                    controller: pesoController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$'))
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Peso (kg)",
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Género
                  TextField(
                    onTap: () => escolherGenero(context, generoController, opcoesGenero),
                    controller: generoController, 
                    showCursor: false,
                    readOnly: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Género",
                    ),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Doenças
                  TextField(
                    onTap: () => escolherDoencas(context, doencasController),
                    controller: doencasController,
                    showCursor: false,
                    readOnly: true,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Doenças",
                    ),
                  ),
                  const SizedBox(height: 32),

                  //Botão Finalizar Registo Utilizador
                  FloatingActionButton(
                    heroTag: "finalizar_registo_conta",
                    onPressed: () async {
                      print("Finalizar Registo Utilizador pressionado!");
                      await finalizarRegisto();
                    },
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    child: const Icon(Icons.create),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );    
  }
}
