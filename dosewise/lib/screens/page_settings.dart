import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:dosewise/controlador_tema.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:http/http.dart" as http;
import "package:dosewise/screens/screen_profileadmin.dart";
import "package:dosewise/veri_device.dart";
import 'dart:convert';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  bool isAdmin = false;
  bool loadingMode = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
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
          isAdmin = list[0] as bool;
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    if (loadingMode) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.05,
            ),
            child: ListView(
              children: [
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Definições",
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        fontSize: size.width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.06),
                ListTile(
                  title: Text(
                    "Modo Escuro",
                    style: TextStyle(
                      fontFamily: "Roboto-Regular",
                      fontSize: size.width * 0.045,
                      color: colorScheme.primary,
                    ),
                  ),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Botão "Menu Admin" no canto inferior direito
          if (isAdmin)
            Positioned(
              bottom: size.height * 0.05,
              right: size.width * 0.06,
              child: FloatingActionButton.extended(
                label: Text("Menu\nAdmin"),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final currentUserId = prefs.getInt("user_id") ?? 0;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ScreenAdminUser(currentUserId: currentUserId),
                    ),
                  );
                },
                backgroundColor: colorScheme.primary,
                icon: Icon(Icons.admin_panel_settings),
              ),
            ),
        ],
      ),
    );
  }
}
