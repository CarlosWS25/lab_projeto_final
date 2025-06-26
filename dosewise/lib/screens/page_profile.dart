import "dart:convert";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;
import "package:dosewise/veri_device.dart";
import "package:dosewise/opcoes_gdd.dart";


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

 

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
          };

          // Preencher os campos com os novos dados
          usernameController.text = list[2];
          anoController.text = "${list[3]}";
          alturaController.text = "${list[4]}";
          pesoController.text = "${list[5]}";
          generoController.text = mapGenero.entries
              .firstWhere((entry) => entry.value == list[6], orElse: () => const MapEntry("", ""))
              .key;

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
  Widget _buildField(
  String label,
  String value,
  TextEditingController controller, {
  VoidCallback? onTap,
  double fontSize = 16,
}) {
  final colorScheme = Theme.of(context).colorScheme; 
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      editMode
          ? TextFormField(
              controller: controller,
              readOnly: onTap != null,
              onTap: onTap,
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontSize: fontSize,
                  color: colorScheme.primary,
                ),
                filled: true,
                fillColor: colorScheme.secondary,
              ),
            )
          : Text(
              "   $label: $value",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: fontSize,
                color: colorScheme.primary,
              ),
            ),
      SizedBox(height: fontSize * 1.25),
    ],
  );
}

  

  @override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final colorScheme = Theme.of(context).colorScheme; 

  if (loadingMode) {
    return const Center(child: CircularProgressIndicator());
  }
  if (userData == null) {
    return const Center(child: Text("Erro ao carregar os dados do utilizador."));
  }

  return Scaffold(
    backgroundColor: colorScheme.onPrimary,
    body: Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),

              Center(
                child: Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? "assets/images/logo_dosewise.png"
                      : "assets/images/logo_dosewise_dark.png",
                  width: size.width * 0.25,
                  height: size.width * 0.25,
                ),
              ),

              SizedBox(height: size.height * 0.02),

              Text(
                "   Informações do Utilizador",
                style: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontSize: size.width * 0.07,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),

              SizedBox(height: size.height * 0.04),

              Text(
                "   ID: ${userData!["id"]}",
                style: TextStyle(
                  fontFamily: "Roboto-Regular",
                  fontSize: size.width * 0.045,
                  color: colorScheme.primary,
                ),
              ),

              SizedBox(height: size.height * 0.03),

              _buildField(
                "Username",
                userData!["username"],
                usernameController,
                fontSize: size.width * 0.045,
              ),
              _buildField(
                "Ano de Nascimento (YYYY)",
                "${userData!["ano_nascimento"]}",
                anoController,
                fontSize: size.width * 0.045,
              ),
              _buildField(
                "Altura (cm)",
                "${userData!["altura_cm"]}",
                alturaController,
                fontSize: size.width * 0.045,
              ),
              _buildField(
                "Peso (kg)",
                "${userData!["peso"]}",
                pesoController,
                fontSize: size.width * 0.045,
              ),
              _buildField(
                "Género",
                userData!["genero"],
                generoController,
                fontSize: size.width * 0.045,
                onTap: () => escolherGenero(
                  context: context,
                  controller: generoController,
                ),
              ),
            ],
          ),
        ),

        Positioned(
          bottom: size.height * 0.04,
          right: size.width * 0.05,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: colorScheme.primary,
            onPressed: () async {
              if (editMode) {
                await updateUserData();
              }
              setState(() {
                editMode = !editMode;
              });
            },
            child: Icon(
              editMode ? Icons.save : Icons.edit,
              color: colorScheme.onPrimary,
              size: size.width * 0.07,
            ),
          ),
        ),
      ],
    ),
  );
}

}
