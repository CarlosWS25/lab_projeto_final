import "package:dosewise/screens/screen_ajudarconv.dart";
import "package:flutter/material.dart";


class WarnAjudarConv extends StatefulWidget {
  const WarnAjudarConv({super.key});
  @override
  WarnAjudarConvState createState() => WarnAjudarConvState();
}

class WarnAjudarConvState extends State<WarnAjudarConv> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenAjudarConv()),
        );
      });
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFA7C4E2),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              """ ainda n sei o texto""",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF1B3568),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    ),
  );
}
}