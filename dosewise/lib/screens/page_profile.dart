import "dart:convert";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;
import "package:dosewise/veri_device.dart";
import "package:flutter/services.dart";
import "package:dosewise/opcoes_gd.dart";


class PageProfile extends StatefulWidget {
  const PageProfile({super.key});

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  // Variáveis para armazenar os dados do utilizador
  Map<String, dynamic>? userData;
  //Indica se os dados estão a ser carregados do backend
  bool loadingMode = true;
  //Indica se modo edição está ativo
  bool editMode = false;

  //Controllers que capturam os dados dos TextFields 
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController doencasController = TextEditingController();

 

  @override
  void initState() {
    super.initState();
    fetchUserData();
    carregarDoencas().then((value) {
    setState(() {
      opcoesDoenca = value;
    });
  });
}

  Future<void> fetchUserData() async {
    //Vai buscar o token de autenticação
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      setState(() {
        loadingMode = false;
      });
      return;
    }

    //Cria o URL usando a função makeApiUri
    final uri = await makeApiUri("/users/me");

    //Faz o peiddo GET a API
    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data["utilizador"];

        //Atualiza os dados do utilizador
        setState(() {
          userData = {
            "is_admin": list[0],
            "id": list[1],
            "username": list[2],
            "ano_nascimento": list[3],
            "altura_cm": list[4],
            "peso": list[5],
            "genero": list[6],
            "doencas": list[7],
          };

          // Preencher os campos com os novos dados
          usernameController.text = list[2];
          anoController.text = "${list[3]}";
          alturaController.text = "${list[4]}";
          pesoController.text = "${list[5]}";
          generoController.text = mapGenero.entries
              .firstWhere((entry) => entry.value == list[6], orElse: () => const MapEntry("", ""))
              .key;
          doencasController.text = list[7];

          loadingMode = false;
        });
      } else {
        setState(() => loadingMode = false);
      }
    } catch (e) {
      print("Erro ao obter dados: $e");
      setState(() => loadingMode = false);
    }
  }

  Future<void> updateUserData() async {
    //Vai buscar o token de autenticação
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return;

    //Cria o URL usando a função makeApiUri
    final uri = await makeApiUri("/users/me");

    // Cria o mapa com os dados atualizados
    final updatedData = {
      "username": usernameController.text,
      "ano_nascimento": int.tryParse(anoController.text),
      "altura_cm": int.tryParse(alturaController.text),
      "peso": double.tryParse(pesoController.text),
      "genero": mapGenero[generoController.text] ?? generoController.text,
      "doencas": doencasController.text,
    };


    //Faz o pedido PUT para atualizar os dados do utilizador
    try {
      final response = await http.put(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        // Atualizar dados locais
        await fetchUserData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados atualizados com sucesso!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao atualizar os dados.")),
        );
      }
    } catch (e) {
      print("Erro ao atualizar: $e");
    }
  }

  //Frontend dos campos de entrada de dados
  Widget _buildField(String label, String value, TextEditingController controller, {VoidCallback? onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        editMode

//Caixas de texto
            ? TextFormField(
                controller: controller,
                readOnly: onTap != null,
                onTap: onTap,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: const TextStyle(
                    fontFamily: "Roboto-Regular",
                    fontSize: 16,
                    color: Color(0xFF1B3568),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              )

//Texto que mostra os dados do utilizador
            : Text(
                "   $label: $value",
                style: const TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontSize: 16,
                  color: Color(0xFF1B3568),
                ),
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  

  @override
Widget build(BuildContext context) {
  //Se os dados estiverem a carregar aparece uma tela de load
  if (loadingMode) {
    return const Center(child: CircularProgressIndicator());
  }
  //Se os dados do utilizador não estiverem carregados, mostra uma mensagem de erro
  if (userData == null) {
    return const Center(child: Text("Erro ao carregar os dados do utilizador."));
  }

  return Scaffold(
    backgroundColor: const Color(0xFFA7C4E2),
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 24),
              Center(

//logo do DoseWise
                child: Image.asset(
                  "assets/images/logo_dosewise.png",
                  width: 100,
                  height: 100,
                ),
              ),
              const SizedBox(height: 16),
              
//Titulo da página
              const Text(
                "   Informações do Utilizador",
                style: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontSize: 28,
                  color: Color(0xFF1B3568),
                ),
              ),

// ID do utilizador
              const SizedBox(height: 40),
              Text("   ID: ${userData!["id"]}",
                style: const TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: 16,
                color: Color(0xFF1B3568),
              )),
              const SizedBox(height: 16),

              _buildField("Username ", userData!["username"], usernameController),
              _buildField("Ano de Nascimento (YYYY) ", "${userData!["ano_nascimento"]}", anoController),
              _buildField("Altura (cm) ", "${userData!["altura_cm"]}", alturaController),
              _buildField("Peso (kg) ", "${userData!["peso"]}", pesoController),
              _buildField("Género ", userData!["genero"], generoController,
                onTap: () => escolherGenero(context: context, controller: generoController)),
              _buildField("Doenças ", userData!["doencas"], doencasController,
                onTap: () => escolherDoenca(context: context, controller: doencasController, opcoes: opcoesDoenca)),

            ],
          ),
        ),
        Positioned(
          top: 780,
          right: 30,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Color(0xFF1B3568),
            onPressed: () async {
              if (editMode) {
                await updateUserData();
              }
              setState(() {
                editMode = !editMode;
              });
            },
            child: Icon(editMode ? Icons.save : Icons.edit, color: Color(0xFFA7C4E2)),
          ),
        ),
      ],
    ),
  );
}
}
