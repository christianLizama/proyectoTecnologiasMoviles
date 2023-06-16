import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class EscanearQr extends StatefulWidget {
  const EscanearQr({Key? key}) : super(key: key);

  @override
  State<EscanearQr> createState() => _EscanearQrState();
}

class _EscanearQrState extends State<EscanearQr> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;
  late String qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text("Escanear QR"),
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Text('Resultado: $qrText'),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      qrController = controller;
    });
    qrController.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code!;
      });
    });
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
