import "package:flutter/material.dart";
import "splashscreen_warn.dart";
import 'dart:async';


class ScreenLoad extends StatefulWidget {
  const ScreenLoad({super.key});
  @override
  ScreenLoadState createState() => ScreenLoadState();
}

class ScreenLoadState extends State<ScreenLoad> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 10), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScreenWarn()
        ),
      );
    });
    }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor:colorScheme.onPrimary,
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Theme.of(context).brightness == Brightness.light
                  ? "assets/images/logo_dosewise.png"
                  : "assets/images/logo_dosewise_dark.png",
              width: 90,
              height: 90,
              fit: BoxFit.contain),
            const SizedBox(height: 1),
            
            Text("dosewise",
              style: TextStyle(
                fontFamily: "Roboto-Regular",  
                fontWeight: FontWeight.bold,
                fontSize: 50,
                letterSpacing: 8.0,
                color: colorScheme.primary)
            ), 
            Text("OVERDOSE PREVENTION APP",
            style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontSize: 20,
                color:colorScheme.primary)
            ),
          ]
        )
      )    
    );
  }
}