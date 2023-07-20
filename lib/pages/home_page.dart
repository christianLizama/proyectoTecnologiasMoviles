import 'package:flutter/material.dart';
import 'package:lugares_cercanos/services/auth.dart';
import '../util/boton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../util/end_drawer.dart';

class HomePage extends StatelessWidget {
  // Constantes de padding (ajústalas según tus necesidades)
  final double horizontalPadding = 30;
  final double verticalPadding = 0;

  List botones = [
    ["Lugares cercanos", "lib/icons/lugares.png", '/lugaresCercanos'],
    ["Escanear QR", "lib/icons/qr.png", '/escanearQR'],
    ["Búsqueda por voz", "lib/icons/microfono.png", '/busquedaVoz'],
    ["Ver mapa", "lib/icons/mapa.png", '/verMapa'],
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener información del usuario actualmente autenticado
    User? user = FirebaseAuth.instance.currentUser;

    // Obtener el tamaño de pantalla del dispositivo
    final Size screenSize = MediaQuery.of(context).size;
    // Calcular el ancho de cada elemento en la cuadrícula (asumiendo 2 elementos por fila)
    final double gridItemWidth =
        (screenSize.width - (horizontalPadding * 2) - 25) / 2;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        shadowColor: const Color.fromARGB(0, 244, 67, 54),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Image.asset('lib/icons/menu.png'),
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
        user: user,
        onSignOutPressed: () {
          AuthServices.signOut(context);
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/images/fondo.jpg"), // Ruta de la imagen de fondo
            fit: BoxFit
                .cover, // Ajusta la imagen para que cubra todo el contenedor
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // app bar
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: verticalPadding,
                ),
              ),

              const SizedBox(height: 80),

              // bienvenida
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "¿Qué lugar te gustaría visitar?",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 150),

              // cuadrícula de botones

              // cuadrícula
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calcular el número de elementos por fila dinámicamente basado en el ancho disponible
                    final int crossAxisCount =
                        (constraints.maxWidth / gridItemWidth).floor();
                    return GridView.builder(
                      itemCount: botones.length,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1 / 1.3,
                      ),
                      itemBuilder: (context, index) {
                        return Boton(
                          nombre: botones[index][0],
                          icono: botones[index][1],
                          ruta: botones[index][2],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[300],
    );
  }
}
