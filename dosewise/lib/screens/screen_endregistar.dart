import "dart:convert";
import "dart:io";
import "package:http/http.dart" as http;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/screens/screen_profile.dart";
import "package:dosewise/veri_device.dart";

class ScreenEndRegistar extends StatefulWidget {
  const ScreenEndRegistar({super.key});

  @override
  State<ScreenEndRegistar> createState() => ScreenEndRegistarState();
}

class ScreenEndRegistarState extends State<ScreenEndRegistar> {
//Capturadores dos dados dos TextFields
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController idadeController = TextEditingController();
  final TextEditingController doencasController = TextEditingController();
  final TextEditingController generoController = TextEditingController();

  

//Calendario data de nascimento
  DateTime? idade;
  Future<void> selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        idade = picked;
        idadeController.text = "${picked.day}/${picked.month}/${picked.year}";
      }
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
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Altura (cm)",
                    ),
                  ),
                  const SizedBox(height: 16),

//Campo de Registar Peso
                  TextField(
                    controller: pesoController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Peso (kg)",
                    ),
                  ),
                  const SizedBox(height: 16),

//Campo de Registar Idade
                  GestureDetector(
                    onTap: () => selecionarData(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: idadeController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          hintText: "Data de Nascimento (dd/mm/aaaa)",
                        ),
                      )        
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
                  const SizedBox(height: 32),

//Botão Finalizar Registo Utilizador
                  FloatingActionButton(
                    heroTag: "finalizar_registo_conta",
                    onPressed: () async {
                      print("Finalizar Registo Utilizador pressionado!");
                      final uri = await makeApiUri("/utilizador/registar");
                      //await finalizarRegisto();
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ScreenProfile()),
                        );
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
