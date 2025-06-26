import "package:flutter/material.dart";
import "page_settings.dart";
import "page_profile.dart";
import "page_guia.dart";
import "page_mainmenu.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int indexPages = 0;

  // Lista de páginas
  final List<Widget> pages = const [
    PageMainMenu(),
    PageProfile(),
    PageGuia(),
    PageSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.onPrimary,

      // Conteúdo principal
      body: SafeArea(
        child: IndexedStack(
          index: indexPages,
          children: pages,
        ),
      ),

      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onPrimary,
        selectedItemColor: colorScheme.secondary,
        currentIndex: indexPages,
        onTap: (int index) {
          setState(() {
            indexPages = index;
          });
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: "Menu Principal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Guia",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Definições",
          ),
        ],
      ),
    );
  }
}
