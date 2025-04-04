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
              width: 300,
              height: 300,
              fit: BoxFit.contain),
            SizedBox(height: 20),
            const Text("DoseWise",
              style: TextStyle(
                fontFamily: "Fontspring-DEMO-clarikaprogeo-md",  
                fontWeight: FontWeight.bold,
                fontSize: 50,
                color:Color(0xFF1B3568),)
            ), 
            const Text("Overdose Control App",
            style: TextStyle(
                fontFamily: "Fontspring-DEMO-clarikaprogeo-md",
                fontSize: 20,
                color:Color(0xFF1B3568),)
            )
          ]
        )
      )    
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3568),
        title: const Text("DoseWise"),
      ),
      body: Center(
        child: const Text("Bem-vindo à Tela Principal!"),
      ),
    );
  }
}