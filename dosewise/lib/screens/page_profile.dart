// lib/screens/page_profile.dart

import "dart:convert";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;
import "package:dosewise/veri_device.dart";
import "package:dosewise/opcoes_gdu.dart";
import "package:dosewise/screens/screen_profileadmin.dart"; // AdminUsersScreen

class PageProfile extends StatefulWidget {
  const PageProfile({super.key});

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  Map<String, dynamic>? userData;
  bool loadingMode = true;
  bool editMode = false;

  // Controllers dos TextFields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController anoController = TextEditingController();
  final TextEditingController alturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController generoController = TextEditingController();
  final TextEditingController doencaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
    carregarDoenca().then((value) {
      setState(() => opcoesDoenca = value);
    });
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) {
      setState(() => loadingMode = false);
      return;
    }

    final uri = await makeApiUri("/users/me");
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
        setState(() {
          userData = {
            "is_admin":       list[0] as bool,
            "id":             list[1] as int,
            "username":       list[2] as String,
            "ano_nascimento": list[3],
            "altura_cm":      list[4],
            "peso":           list[5],
            "genero":         list[6],
            "doenca_pre_existente": list[7],
          };
          usernameController.text = list[2];
          anoController.text      = "${list[3]}";
          alturaController.text   = "${list[4]}";
          pesoController.text     = "${list[5]}";
          generoController.text   = mapGenero.entries
              .firstWhere((e) => e.value == list[6], orElse: () => const MapEntry("", ""))
              .key;
          doencaController.text   = list[7] ?? "";
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
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return;

    final uri = await makeApiUri("/users/me");
    final updatedData = {
      "username": usernameController.text,
      "ano_nascimento": int.tryParse(anoController.text),
      "altura_cm":      int.tryParse(alturaController.text),
      "peso":           double.tryParse(pesoController.text),
      "genero":         mapGenero[generoController.text] ?? generoController.text,
      "doenca_pre_existente": doencaController.text,
    };

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
    final paddingTop = MediaQuery.of(context).padding.top;
    final colorScheme = Theme.of(context).colorScheme;

    if (loadingMode) {
      return const Center(child: CircularProgressIndicator());
    }
    if (userData == null) {
      return const Center(child: Text("Erro ao carregar os dados do utilizador."));
    }

    final bool isAdmin = userData!["is_admin"] as bool;
    final int  myId    = userData!["id"]       as int;

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
                  "   ID: $myId",
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
                _buildField(
                  "Doenças Pré-existentes",
                  userData!["doenca_pre_existente"],
                  doencaController,
                  fontSize: size.width * 0.045,
                  onTap: () => escolherDoenca(
                    context: context,
                    controller: doencaController,
                    opcoes: opcoesDoenca,
                  ),
                ),
              ],
            ),
          ),

          // botão de editar/salvar
          Positioned(
            bottom: size.height * 0.04,
            right: size.width * 0.05,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: colorScheme.primary,
              onPressed: () async {
                if (editMode) await updateUserData();
                setState(() => editMode = !editMode);
              },
              child: Icon(
                editMode ? Icons.save : Icons.edit,
                color: colorScheme.onPrimary,
                size: size.width * 0.07,
              ),
            ),
          ),

          // botão solto de admin
          if (isAdmin)
            Positioned(
              top: paddingTop + 8,
              right: size.width * 0.05,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: colorScheme.primary,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminUsersScreen(
                        currentUserId: myId,  // evita o self-delete
                      ),
                    ),
                  );
                },
                tooltip: "Gerir utilizadores",
                child: Icon(
                  Icons.admin_panel_settings,
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
