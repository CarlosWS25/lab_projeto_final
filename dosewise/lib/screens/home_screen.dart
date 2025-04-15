import "package:flutter/material.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}
class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFA7C4E2),
      body: Stack(
        children:[
//Botão Ajudar
          Positioned(
            bottom: 450,
            right: 225,
          child: SizedBox(
            width: 150,
            height: 100,
          child:FloatingActionButton.extended(
            heroTag: "ajudar",

            onPressed: () {
              print("Botão Ajudar pressionado!");
            },
            backgroundColor: Color(0xFF1B3568),
            label: Column(
              children: const [ Text("Ajudar",
                style: TextStyle(
                color:Color(0xFFA7C4E2),    
                fontSize: 20,
                ),
              )
              ]
            ),
          ),
          ),
          ),
//Botão Ajudar Convidado
          Positioned(
            bottom: 450,
            right: 50,
          child: SizedBox(
            width: 150,
            height: 100,
          child:FloatingActionButton.extended(
            heroTag: "ajudar_convidado",

            onPressed: () {
              print("Botão Ajudar Convidado pressionado!");
            },
            backgroundColor: Color(0xFF1B3568),
            label: Column(
              children: const [ Text("    Ajudar \n Convidado",
                style: TextStyle(
                color:Color(0xFFA7C4E2),    
                fontSize: 20,
                ),
              )
              ]
            ),
          ),
          ),
          ),
//Botão Alarme
          Positioned(
            bottom: 300,
            right: 225,
          child: SizedBox(
            width: 150,
            height: 100,
          child:FloatingActionButton.extended(
            heroTag: "alarme",

            onPressed: () {
              print("Botão Alarme pressionado!");
            },
            backgroundColor: Color(0xFF1B3568),
            label: Column(
              children: const [ Text("Alarme",
                style: TextStyle(
                color:Color(0xFFA7C4E2),    
                fontSize: 20,
                ),
              )
              ]
            ),
          ),
          ),
          ),
//Botão Alerta Amigo
          Positioned(
            bottom: 300,
            right: 50,
          child: SizedBox(
            width: 150,
            height: 100,
          child:FloatingActionButton.extended(
            heroTag: "alerta_amigo",

            onPressed: () {
              print("Botão Alerta Amigo pressionado!");
            },
            backgroundColor: Color(0xFF1B3568),
            label: Column(
              children: const [ Text("Alerta Amigo",
                style: TextStyle(
                color:Color(0xFFA7C4E2),    
                fontSize: 20,
                ),
              )
              ]
            ),
          ),
          ),
          ),
        ]
      ),

//Barra Inferior
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF1B3568),
        unselectedItemColor: Color(0xFFA7C4E2),
        selectedItemColor: Color(0xFFFFFFFF),
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const[
//Main Menu
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: "Main Menu",
          ),
//Perfil
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
//???
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "???",
          ),
//Defenições
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Defenições",
          ),
        ],
      )
    ); 
  }
}