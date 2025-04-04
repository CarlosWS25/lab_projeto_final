import"package:flutter/material.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFA7C4E2),
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo_dosewise.png",
              width: 90,
              height: 90,
              fit: BoxFit.contain),
            SizedBox(height: 1),
            const Text("dosewise",
              style: TextStyle(
                fontFamily: "Fontspring-DEMO-clarikaprogeo-md",  
                fontWeight: FontWeight.bold,
                fontSize: 50,
                letterSpacing: 8.0,
                color:Color(0xFF1B3568),)
            ), 
            const Text("OVERDOSE PREVENTION APP",
            style: TextStyle(
                fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
                fontSize: 20,
                color:Color(0xFF1B3568),)
            ),
          ]
        )
      )    
    );
  }
}

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
            bottom: 500,
            right: 250,
            child:FloatingActionButton.extended(
              heroTag: "ajudar",

              onPressed: () {
                print("Botão Ajudar pressionado!");
              },
              backgroundColor: Color(0xFF1B3568),
              label: Column(
                mainAxisSize: MainAxisSize.min,
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
//Botão Ajudar Convidado
          Positioned(
            bottom: 500,
            right: 50,
            child:FloatingActionButton.extended(
              heroTag: "ajudar_convidado",

              onPressed: () {
                print("Botão Ajudar Convidado pressionado!");
              },
              backgroundColor: Color(0xFF1B3568),
              label: Column(
                mainAxisSize: MainAxisSize.min,
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
//Botão Alarme
          Positioned(
            bottom: 350,
            right: 250,
            child:FloatingActionButton.extended(
            heroTag: "alarme",

            onPressed: () {
              print("Botão Alarme pressionado!");
            },
            backgroundColor: Color(0xFF1B3568),
            label: Column(
                mainAxisSize: MainAxisSize.min,
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
//Botão Alerta Amigo
          Positioned(
            bottom: 350,
            right: 50,
            child:FloatingActionButton.extended(
            heroTag: "alerta_amigo",
            onPressed: () {
              print("Botão Alerta Amigo pressionado!");
            },
            backgroundColor: Color(0xFF1B3568),
            label: Column(
                mainAxisSize: MainAxisSize.min,
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
