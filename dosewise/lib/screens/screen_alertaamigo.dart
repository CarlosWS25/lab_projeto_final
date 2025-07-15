import "dart:convert";
import "package:flutter/material.dart";
import "package:location/location.dart";
import "package:permission_handler/permission_handler.dart" as perm;
import "package:url_launcher/url_launcher.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";
import "package:dosewise/veri_device.dart";

class ScreenAlertaAmigo extends StatefulWidget {
  const ScreenAlertaAmigo({Key? key}) : super(key: key);

  @override
  State<ScreenAlertaAmigo> createState() => ScreenAlertaAmigoState();
}

class ScreenAlertaAmigoState extends State<ScreenAlertaAmigo> {
  final TextEditingController _nameController   = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final List<Friend> _friends = [];
  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _enviarSmsViaIntent(String numeros, String mensagem) async {
    final Uri smsUri = Uri(
      scheme: "sms",
      path: numeros,
      queryParameters: {"body": mensagem},
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw "Não foi possível abrir o app SMS.";
    }
  }

  Future<void> _loadFriends() async {
    try {
      final uri = await makeApiUri("/friends/amigos");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          _friends
            ..clear()
            ..addAll(data.map((item) => Friend(
              name:   item["nome_do_amigo"],
              number: item["numero_amigo"],
            )));
        });
      } else if (response.statusCode != 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao carregar amigos: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Falha GET amigos: $e");
    }
  }

  Future<void> _addFriend() async {
    final name   = _nameController.text.trim();
    final number = _numberController.text.trim();
    if (name.isEmpty || number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha nome e número.")),
      );
      return;
    }
    if (_friends.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Limite de 3 amigos atingido.")),
      );
      return;
    }

    try {
      final uri = await makeApiUri("/friends/amigos");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "nome_do_amigo": name,
          "numero_amigo":  number,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _friends.add(Friend(name: name, number: number));
          _nameController.clear();
          _numberController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Exception POST /friends/amigos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha na requisição: $e")),
      );
    }
  }

  Future<void> _removeFriend(int index) async {
    final friend = _friends[index];
    try {
      final uri = await makeApiUri("/friends/amigos");
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      final req = http.Request("DELETE", uri)
        ..headers.addAll({
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        })
        ..body = jsonEncode({
          "nome_do_amigo":   friend.name,
          "numero_amigo":    friend.number,
        });
      final streamed = await req.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        setState(() => _friends.removeAt(index));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Exception DELETE /friends/amigos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Falha na requisição: $e")),
      );
    }
  }

  Future<void> _alertarAmigos() async {
    final statusSms = await perm.Permission.sms.request();
    if (!statusSms.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissão SMS não concedida.")),
      );
      return;
    }

    bool serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled &&
        (serviceEnabled = await _locationService.requestService()) != true) {
      return;
    }
    var permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied &&
        (permissionGranted = await _locationService.requestPermission()) !=
            PermissionStatus.granted) {
      return;
    }

    try {

      final loc = await _locationService.getLocation();
      final mensagem = 
        "Preciso de ajuda! Minha localização: https://www.google.com/maps/search/?api=1&query=${loc.latitude},${loc.longitude}";

      final todosNumeros = _friends.map((f) => f.number).join(",");

      await _enviarSmsViaIntent(todosNumeros, mensagem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SMS preparado para todos os amigos.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao enviar alerta: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.onPrimary,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.08,
          vertical: size.height * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.02),


// Titulo Alerta Amigo  
            Text(
              "Alerta Amigos",
              style: TextStyle(
                fontSize: size.width * 0.08,
                color:   colorScheme.primary,
              ),
            ),
            SizedBox(height: size.height * 0.02),

// Campo Nome do Amigo
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                filled:    true,
                fillColor: colorScheme.secondary,
                border:    const OutlineInputBorder(),
                hintText:  "Nome do Amigo",
                hintStyle: TextStyle(fontSize: size.width * 0.045),
              ),
            ),
            SizedBox(height: size.height * 0.02),

// Campo Número do Amigo
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                filled:    true,
                fillColor: colorScheme.secondary,
                border:    const OutlineInputBorder(),
                hintText:  "Número do Amigo",
                hintStyle: TextStyle(fontSize: size.width * 0.045),
              ),
            ),
            SizedBox(height: size.height * 0.04),

// Botão Adicionar Amigo
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.extended(
                    onPressed: () async {
                      print("Botão Adicionar Amigo pressionado!");
                      await _addFriend();
                    },
                    backgroundColor: colorScheme.primary,
                    label: Text(
                      "Adicionar Amigo",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.onPrimary,
                        fontSize: size.width * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Lista de Amigos
                  Column(
                    children: List.generate(3, (i) {
                      final has = i < _friends.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: has
                                ? colorScheme.primary
                                : colorScheme.primary.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(size.width * 0.02),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              has
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _friends[i].name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(_friends[i].number),
                                    ],
                                  )
                                : Text(
                                    "Slot ${i + 1} vazio",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: colorScheme.onSurface.withOpacity(0.6),
                                    ),
                                  ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: has ? () => _removeFriend(i) : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      width:  size.width * 0.25,
                      height: size.width * 0.25,
                      child: FloatingActionButton(
                        heroTag: "botao_alertar_amigos",
                        onPressed: _friends.isEmpty ? null : _alertarAmigos,
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          "Alertar\nAmigos",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: size.width * 0.05,
                            color:    colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Friend {
  final String name;
  final String number;
  Friend({required this.name, required this.number});
}
