import "package:flutter/material.dart";

class PageProfile extends StatelessWidget {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFA7C4E2),
        body: Stack( 
          children: [
            Positioned(
          bottom: 450,
          right: 100,
        child: Text("Dosewise",
          style: TextStyle(
            fontFamily: "Fontspring-DEMO-clarikaprogeo-md",  
            fontWeight: FontWeight.bold,
            fontSize: 50,
            color:Color(0xFF1B3568),)
        ),
        ),
//logo Dosewise
            Positioned(
              bottom: 520,
              right: 130,
            child: Image.asset("assets/images/logo_dosewise.png",
              width: 150,
              height: 150,
              fit: BoxFit.contain),
            ),
          ]
        )
    );    
  }
}