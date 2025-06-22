import 'dart:convert';
import 'package:dosewise/screens/screen_inicial.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dosewise/veri_device.dart'; 

class ScreenRecuperar extends StatefulWidget {
  const ScreenRecuperar({super.key});

  @override
  State<ScreenRecuperar> createState() => ScreenRecuperarState();
}

class ScreenRecuperarState extends State<ScreenRecuperar> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController recoveryKeyController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPasswordController = TextEditingController();

  bool _loading = false;

  Future<void> recuperarPassword() async {
    final username = usernameController.text.trim();
    final recoveryKey = recoveryKeyController.text.trim();
    final newPassword = passwordController.text;
    final confirmPassword = confirmarPasswordController.text;

    if (username.isEmpty || recoveryKey.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As passwords não coincidem.')),
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    final uri = await makeApiUri("/recover-password");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "recovery_key": recoveryKey,
          "new_password": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        print("Password alterada com sucesso!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password alterada com sucesso!")),
        );
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScreenInicial()),
        );
      } else {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["detail"] ?? "Erro ao recuperar password.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na requisição: $e")),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    recoveryKeyController.dispose();
    passwordController.dispose();
    confirmarPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          // Logo Dosewise
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    "Recuperar Palavra-Passe",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: 32,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Username
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Username",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  const SizedBox(height: 16),

                  // Recovery key
                  TextField(
                    controller: recoveryKeyController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Código de recuperação",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  const SizedBox(height: 16),

                  // Nova password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Nova password",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  const SizedBox(height: 16),

                  // Confirmar nova password
                  TextField(
                    controller: confirmarPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: OutlineInputBorder(),
                      hintText: "Confirmar nova password",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(color: colorScheme.primary),
                  ),
                  const SizedBox(height: 32),

                  // Botão para recuperar password
                  FloatingActionButton(
                    heroTag: "botao_recuperar_password",
                    onPressed: _loading ? null : recuperarPassword,
                    foregroundColor: colorScheme.primary,
                    backgroundColor: colorScheme.secondary,
                    child: _loading
                        ? CircularProgressIndicator(color: colorScheme.primary)
                        : const Icon(Icons.key),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
