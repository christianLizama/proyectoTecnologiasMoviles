import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lugares_cercanos/pages/agregar_lugar.dart';
import 'package:lugares_cercanos/pages/busqueda_voz.dart';
import 'package:lugares_cercanos/pages/favoritos.dart';
import 'package:lugares_cercanos/pages/register.dart';
import 'pages/home_page.dart';
import 'pages/page_404.dart';
import 'pages/lugares_cercanos.dart';
import 'pages/mapa.dart';
import 'pages/escanear_qr.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/login.dart';
import 'pages/login_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _routes = {
    '/': (context) => const WelcomePage(),
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => HomePage(),
    '/busquedaVoz': (context) => const BusquedaVoz(),
    '/lugaresCercanos': (context) => const LugaresCercanos(
          searchText: '',
        ),
    '/escanearQR': (context) => const EscanearQr(),
    '/verMapa': (context) => const MapSample(),
    '/addLugar': (context) => const AgregarLugarScreen(),
    '/favoritos': (context) => const MisFavoritos(
          searchText: '',
        ),
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
