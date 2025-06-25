class ScreenEndAjudaState extends State<ScreenEndAjuda> {
  final BleManager bleManager = BleManager(); // <- se ainda não adicionaste

  @override
  void initState() {
    super.initState();
    requestPermissions();
    bleManager.startScanAndConnect(); // começa a procurar o medidor
  }

  Future<void> requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  Future<void> finalizarAjuda() async {
    final double? doseDouble = double.tryParse(widget.dose);
    final uri = await makeApiUri("/predict_overdose");

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "doencas": widget.doencas,
          "sintomas": widget.sintomas,
          "uso_suspeito": widget.uso,
          "dose_g": doseDouble,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Dados adicionados com sucesso!")),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao adicionar os seus dados: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro na requisição: $e")),
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Finalizar Ajuda")),
    body: Center(
      child: StreamBuilder<double>(
        stream: bleManager.glucoseStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              "Glicemia: ${snapshot.data!.toStringAsFixed(1)} mg/dL",
              style: const TextStyle(fontSize: 24),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("À espera da leitura da glicemia..."),
              ],
            );
          }
        },
      ),
    ),
  );
}
}
