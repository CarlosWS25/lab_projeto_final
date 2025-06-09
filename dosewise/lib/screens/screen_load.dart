import "package:flutter/material.dart";
import "screen_inicial.dart";


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
          MaterialPageRoute(builder: (context) => const ScreenInicial()),
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