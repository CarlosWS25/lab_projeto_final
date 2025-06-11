import "dart:convert";
import "package:http/http.dart" as http;
import "package:flutter/services.dart";
import "package:flutter/material.dart";
import "package:dosewise/screens/screen_inicial.dart";
import "package:dosewise/veri_device.dart";

class ScreenEndRegistar extends StatefulWidget {
  // Campos finais que armazenam os dados do utilizador
  final String username;
  final String password;

  // Construtor da classe, com parâmetros obrigatórios
  const ScreenEndRegistar({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  State<ScreenEndRegistar> createState() => ScreenEndRegistarState();
}

class ScreenEndRegistarState extends State<ScreenEndRegistar> {
  //Controllers que capturam os dados dos TextFields  
  final TextEditingController anoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController doencasController = TextEditingController();

//Função que completa o registo do utilzador
Future<void> finalizarRegisto() async {
    final ano = anoController.text.trim();
    final altura = alturaController.text.trim();
    final peso = pesoController.text.trim();
    final genero = generoController.text.trim();
    final doencas = doencasController.text.trim();

    //Validação dos campos
    if (ano.isEmpty || altura.isEmpty || peso.isEmpty || genero.isEmpty || doencas.isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

  //Transforma o dados num formato compatível com a base de dados
    final Map<String, String> mapGenero = {
    "Male": "M",
    "Female": "F",
    };

    final int? anoNascimentoInt = int.tryParse(ano);
    final int? alturaInt = int.tryParse(altura);
    final double? pesoDouble = double.tryParse(peso);
    final generoEnviado = mapGenero[genero] ?? genero;
    

    final uri = await makeApiUri("/users/");

    try {
      // Envia os dados do utilizador para a Base de Dados
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
          MaterialPageRoute(builder: (context) => const ScreenInicial()),
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
  final List<String> opcoesGenero = ["Male", "Female"];
  void escolherGenero(BuildContext context, TextEditingController controller, List<String> opcoes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select your gender"),
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


  
  List<String> opcoesDoencas = [];
  @override
  void initState() {
    super.initState();
    carregarDoencas();
  }

  //Caixa de opções de doenças
  Future<void> carregarDoencas() async {
    final String listaDoencas = await rootBundle.loadString("assets/txt/doencas.txt");
    setState(() {
      opcoesDoencas = listaDoencas
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    });
  }

  //Frontend da caixa que escolher as doenças
  void escolherDoencas(BuildContext context, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select your disease"),
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
  //Frontend do ecrã de registo
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

                  //Título de Finalizar Registo
                  Text("Finalize Registration",
                  style: TextStyle(
                    fontFamily: "Roboto-Regular",
                    fontSize: 32,
                    color:Color(0xFF1B3568),
                  ),
                  ),
                  const SizedBox(height: 32),

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
                      hintText: "Year of Birth",
                      hintStyle: TextStyle(color:Color(0xFF1B3568)),
                    ),
                    style: TextStyle(color:Color(0xFF1B3568)),
                  ),
                  const SizedBox(height: 16),

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
                      hintText: "Height (cm)",
                      hintStyle: TextStyle(color:Color(0xFF1B3568)),
                    ),
                    style: TextStyle(color:Color(0xFF1B3568)),
                  ),
                  const SizedBox(height: 16),

                  //Campo de Registar Peso
                  TextField(
                    controller: pesoController,
                    showCursor: false,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r"^\d{0,3}(\.\d{0,2})?$"))
                    ],
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Weight (kg)",
                      hintStyle: TextStyle(color:Color(0xFF1B3568)),
                    ),
                    style: TextStyle(color:Color(0xFF1B3568)),
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
                      hintText: "Gender",
                      hintStyle: TextStyle(color:Color(0xFF1B3568)),
                    ),
                    style: TextStyle(color:Color(0xFF1B3568)),
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
                      hintText: "Diseases",
                      hintStyle: TextStyle(color:Color(0xFF1B3568)),
                    ),
                    style: TextStyle(color:Color(0xFF1B3568)),
                  ),
                  const SizedBox(height: 32),

                  //Botão Finalizar Registo Utilizador
                  FloatingActionButton(
                    heroTag: "finalizar_registo_conta",
                    onPressed: () async {
                      print("Finalizar Registo Utilizador pressionado!");
                      await finalizarRegisto();
                    },
                    foregroundColor: const Color(0xFF1B3568),
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
  
    @override
    void dispose() {
      anoController.dispose();
      alturaController.dispose();
      pesoController.dispose();
      generoController.dispose();
      doencasController.dispose();
      super.dispose();
    }   
  }

