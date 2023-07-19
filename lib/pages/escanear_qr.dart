import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lugares_cercanos/pages/vista_lugar.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../util/lugar.dart';
import '../services/firebase_services.dart';
import '../util/end_drawer.dart'; // Importa el componente EndDrawer
import '../services/auth.dart'; // Importa el servicio de autenticación

class EscanearQr extends StatefulWidget {
  const EscanearQr({Key? key}) : super(key: key);

  @override
  State<EscanearQr> createState() => _EscanearQrState();
}

class _EscanearQrState extends State<EscanearQr> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController qrController;
  late String qrText = '';

  void navigateToLugarDetalle(Lugar lugar) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LugarDetalle(lugar: lugar),
      ),
    );
  }

  void buscarLugarEnFirebase(String nombreLugar) async {
    Lugar? lugar = await getLugarByNameFromFirebase(nombreLugar);
    if (lugar != null) {
      navigateToLugarDetalle(lugar);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Lugar no encontrado'),
          content: const Text('No se encontró el lugar en la base de datos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text("Escanear QR"),
        actions: [
          Builder(
            builder: (BuildContext context) {
              // Utiliza Builder para crear un nuevo contexto que contiene el Scaffold
              return IconButton(
                icon: Image.asset(
                  'lib/icons/menu.png', // Reemplaza la ruta con la ubicación de tu imagen
                ),
                iconSize: 35,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: EndDrawer(
        user: FirebaseAuth.instance.currentUser,
        onSignOutPressed: () {
          AuthServices.signOut(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
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
        buscarLugarEnFirebase(
            qrText); // Llamada al método para buscar el lugar en Firebase.
      });
    });
  }

  @override
  void dispose() {
    qrController.dispose();
    super.dispose();
  }
}
