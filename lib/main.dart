import 'package:flutter/material.dart';
import 'package:lugares_cercanos/pages/busqueda_voz.dart';
import 'pages/home_page.dart';
import 'pages/page_404.dart';
import 'pages/lugares_cercanos.dart';
import 'pages/mapa.dart';
import 'pages/escanear_qr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routes = {
    '/': (context) => const HomePage(),
    '/busquedaVoz': (context) => const BusquedaVoz(),
    '/lugaresCercanos': (context) => const LugaresCercanos(),
    '/escanearQR': (context) => const EscanearQr(),
    '/verMapa': (context) => const MapSample(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: _routes,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Page404(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
