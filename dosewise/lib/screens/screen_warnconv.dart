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
  final colorScheme = Theme.of(context).colorScheme;
  return Scaffold(
    backgroundColor: colorScheme.onPrimary,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              """ ainda n sei o texto""",
              style: TextStyle(
                fontFamily: "Roboto-Regular",
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 1.5,
                color: colorScheme.primary,
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