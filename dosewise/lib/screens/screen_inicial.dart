import "package:flutter/material.dart";
import "package:dosewise/screens/screen_login.dart";
import "package:dosewise/screens/screen_registar.dart";


class ScreenInicial extends StatelessWidget {
  const ScreenInicial({super.key});

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
                  fontFamily: "Roboto-Regular",  
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

//Botão de Login de Perfil
            Positioned(
              bottom: 325,
              right: 30,
              child: SizedBox(
                width: 350,
                height: 50,
                child: FloatingActionButton.extended(
                  heroTag: "login_perfil",
                  onPressed: () {
                    print("Botão Login de Perfil pressionado!");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ScreenLogin()),
                    );
                  },
                backgroundColor: const Color(0xFF1B3568),
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Login",           
                      style: TextStyle(
                        fontFamily: "Roboto-Regular",
                        color: Color(0xFFA7C4E2),
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
                ),
              ),
            ),
            
//Botão de Registar Perfil
            Positioned(
              bottom: 250,
              right: 30,
              child: SizedBox(
                width: 350,
                height: 50,
                child: FloatingActionButton.extended(
                  heroTag: "registar_perfil",
                  onPressed: () {
                    print("Botão Registar Perfil pressionado!");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistarScreen()),
                    );
                  },
                  backgroundColor: const Color(0xFF1B3568),
                  label: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("Criar conta",
                        style: TextStyle(
                          fontFamily: "Roboto-Regular",
                          color: Color(0xFFA7C4E2),
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]
        )
    );    
  }
}