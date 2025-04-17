import "package:flutter/material.dart";
import "settings_page.dart";
import "profile_page.dart";
import "random_page.dart";
import "mainmenu_page.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int IndexPages = 0;

  final List<Widget> pages = const [
    MainMenuPage(),
    ProfilePage(),
    RandomPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA7C4E2),
      body: IndexedStack(
        index: IndexPages,
        children: pages,
      ),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: "Main Menu",
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