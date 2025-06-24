import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:dosewise/opcoes_gdd.dart";
import "package:dosewise/screens/screen_endajuda.dart";


class ScreenAjuda2 extends StatefulWidget {
  final String uso;
  final String dose;

  const ScreenAjuda2({
    super.key,
    required this.uso,
    required this.dose,
  });


  @override
  State<ScreenAjuda2> createState() => ScreenAjuda2State();
}

class ScreenAjuda2State extends State<ScreenAjuda2> {
  final TextEditingController doencasController = TextEditingController();
  final TextEditingController sintomasController = TextEditingController();


  Future<void> continuarAjuda() async {
    final doencas = doencasController.text.trim();
    final sintomas = sintomasController.text.trim();

    if(doencas.isEmpty || sintomas.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScreenEndAjuda(
          uso: widget.uso,
          dose: widget.dose,
          doencas: doencas,
          sintomas: sintomas,
        ),
      ),
    );
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
                      continuarAjuda();
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

  
