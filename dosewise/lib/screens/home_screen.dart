import "package:flutter/material.dart";
import "page_settings.dart";
import "page_profile.dart";
import "page_random.dart";
import "page_mainmenu.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int IndexPages = 0;

  // Lista de páginas 
  final List<Widget> pages = const [
    PageMainMenu(),
    PageProfile(),
    PageRandom(),
    PageSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C4E2),
      body: IndexedStack(
        index: IndexPages,
        children: pages,
      ),

      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1B3568),
        unselectedItemColor: const Color(0xFFA7C4E2),
        selectedItemColor: Colors.white,
        currentIndex: IndexPages,
        onTap: (int index) {
          setState(() {
            IndexPages = index;
          });
        },

        // Itens da barra de navegação
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
            icon: Icon(Icons.add),
            label: "???",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Defenições",
          ),
        ],
      ),
    );
  }
}