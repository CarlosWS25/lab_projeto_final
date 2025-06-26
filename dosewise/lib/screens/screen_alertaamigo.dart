import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:url_launcher/url_launcher.dart';

class ScreenAlertaAmigo extends StatelessWidget {
  const ScreenAlertaAmigo({super.key});

  Future<void> enviarSmsViaIntent(String numero, String mensagem) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: numero,
      queryParameters: <String, String>{'body': mensagem},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Não foi possível abrir o app SMS.';
    }
  }

  Future<void> alertarAmigos(BuildContext context) async {
    final Location location = Location();

    // Pedir permissão SMS explicitamente via permission_handler
    final statusSms = await perm.Permission.sms.request();
    if (!statusSms.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permissão SMS não concedida.")),
      );
      return;
    }

    // Pedir e ativar localização
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    try {
      final locationData = await location.getLocation();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;

      final mensagem =
          "Preciso de ajuda! A minha localização é: https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

      const numeroFixo = "351966650501";

      print("Tentando abrir app SMS para $numeroFixo com a mensagem: $mensagem");

      await enviarSmsViaIntent(numeroFixo, mensagem);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("App SMS aberta com a mensagem pronta.")),
      );
    } catch (e) {
      print("Erro ao abrir app SMS: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao enviar alerta.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          // Logo Dosewise
          Positioned(
            top: size.height * 0.1,
            right: size.width * 0.1,
            child: Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
              width: size.width * 0.25,
              height: size.width * 0.25,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.1),
                  Text(
                    "Adicionar Amigo",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.08,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Nome do Amigo",
                      hintStyle: TextStyle(fontSize: size.width * 0.045),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colorScheme.secondary,
                      border: const OutlineInputBorder(),
                      hintText: "Número do Amigo",
                      hintStyle: TextStyle(fontSize: size.width * 0.045),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        heroTag: "botao_adicionar_amigo",
                        onPressed: () {
                          print("Botão Adicionar Amigo pressionado!");
                        },
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.person_add),
                      ),
                      FloatingActionButton(
                        heroTag: "botao_remover_amigo",
                        onPressed: () {
                          print("Botão Remover Amigo pressionado!");
                        },
                        backgroundColor: colorScheme.primary,
                        child: const Icon(Icons.person_remove),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: SizedBox(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      child: FloatingActionButton(
                        heroTag: "botao_alertar_amigos",
                        onPressed: () {
                          print("Botão Alerta Amigo pressionado!");
                          alertarAmigos(context);
                        },
                        backgroundColor: colorScheme.primary,
                        child: Text(
                          "Alertar\nAmigo",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Roboto-Regular",
                            fontSize: size.width * 0.05,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
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
