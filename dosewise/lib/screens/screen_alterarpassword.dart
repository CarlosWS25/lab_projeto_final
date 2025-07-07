import 'dart:convert';
import 'package:dosewise/screens/screen_inicial.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dosewise/veri_device.dart'; 

class ScreenAlterarPassword extends StatefulWidget {
  const ScreenAlterarPassword({super.key});

  @override
  State<ScreenAlterarPassword> createState() => ScreenAlterarPasswordState();
}

class ScreenAlterarPasswordState extends State<ScreenAlterarPassword> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController recoveryKeyController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmarPasswordController = TextEditingController();

  bool _loading = false;

  Future<void> alterarPassword() async {
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
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(newPassword) || !RegExp(r'(?=.*[a-z])').hasMatch(newPassword) || !RegExp(r'(?=.*\d)').hasMatch(newPassword) || !RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(newPassword)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("A password deve conter pelo menos uma letra maiúscula, uma letra minúscula, um número e um símbolo especial")),
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
          SnackBar(content: Text(data["detail"] ?? "Erro ao Alterar password.")),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [

//logo Dosewise
          Positioned(
            top: size.height * 0.08,
            right: size.width * 0.08,
            child: Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
              width: size.width * 0.3,
              height: size.width * 0.3,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.12),

// Titulo Alterar Palavra-Passe
                  Text(
                    "Alterar Password",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.08,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

//TextField Username
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Username",
                      hintStyle: TextStyle(
                        color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

// TextField Código de Recuperação
                  TextField(
                    controller: recoveryKeyController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Código de recuperação",
                      hintStyle: TextStyle(
                        color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

// TextField Nova Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Nova password",
                      hintStyle: TextStyle(
                        color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

// TextField Confirmar Nova Password
                  TextField(
                    controller: confirmarPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Confirmar nova password",
                      hintStyle: TextStyle(color: colorScheme.primary),
                    ),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: size.width * 0.045,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

// Botão Alterar Password
                  FloatingActionButton.extended(
                    onPressed: _loading ? null : alterarPassword,
                    backgroundColor: colorScheme.primary,
                    label: Text(
                      "Alterar Password",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: colorScheme.onPrimary,
                        fontSize: size.width * 0.05,
                      ),
                    ),
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
