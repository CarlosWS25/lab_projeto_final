import "dart:convert";
import "package:dosewise/screens/home_screen.dart";
import "package:http/http.dart" as http;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/veri_device.dart";
import "package:dosewise/opcoes_gdd.dart";

class ScreenEndAjuda extends StatefulWidget{
  final String drogas;
  final String quantidades;

  const ScreenEndAjuda({
    super.key,
    required this.drogas,
    required this.quantidades,
  });

  @override
  State<ScreenEndAjuda> createState() => ScreenEndAjudaState();
}

  class ScreenEndAjudaState extends State<ScreenEndAjuda>{
    final TextEditingController doencasController = TextEditingController();
    final TextEditingController sintomasController = TextEditingController();


  Future<void> finalizarAjuda() async {
    final doencas = doencasController.text.trim();
    final sintomas = sintomasController.text.trim();
  
    if(doencas.isEmpty || sintomas.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    final double? quantidadesDouble = double.tryParse(widget.quantidades); 

    final uri = await makeApiUri("/saude/");


    try {
      // Envia os dados do utilizador para a Base de Dados
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "doencas": doencas,
          "sintomas": sintomas,
          "droga_usada": widget.drogas,
          "quantidade": quantidadesDouble,
        }),
      );

    if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados adicionados com sucesso!")),
        );
        //final data = jsonDecode(response.body);
         Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        }else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao adicionar os seus dados: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na requisição: $e")),
      );
    }
  }

  @override
    void initState() {
      super.initState();
      carregarDoencas().then((value) {
        setState(() {
          opcoesDoenca = value;
        });
      });
    }


@override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [

          //Logo Dosewise
          Positioned(
            top: 50,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
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
                  const SizedBox(height: 32),

//Título do Ajuda 
                  Text("Preencha os seguintes campos",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: 32,
                      color:colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

//Campo de Doencas
                  TextField(
                    onTap: () => escolherDoenca(context: context, controller: doencasController, opcoes: opcoesDoenca),
                    controller: doencasController,
                    showCursor: false,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Doenças prévias",
                      hintStyle: TextStyle(color:colorScheme.primary),
                    ),
                    style: TextStyle(color:colorScheme.primary),
                  ),
                  const SizedBox(height: 16),

//Campo de sintomas
                  TextField(
                    controller: sintomasController,
                    showCursor: false,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Sintomas",
                      hintStyle: TextStyle(color:colorScheme.primary),
                    ),
                    style: TextStyle(color:colorScheme.primary),
                  ),
                  const SizedBox(height: 32),
                  
//Botão Começar Ajuda
                  FloatingActionButton(
                    heroTag: "finalizar_ajuda_utilizador",
                    onPressed: () async {
                      print("Botão Finalizar Ajudar pressionado!");
                      finalizarAjuda();
                    },
                    foregroundColor: colorScheme.primary,
                    backgroundColor: colorScheme.secondary,
                    child: const Icon(Icons.create_outlined),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );    
  }

  @override
  void dispose() {
    doencasController.dispose();
    sintomasController.dispose();
    super.dispose();
  }
}

  
