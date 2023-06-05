import 'package:flutter/material.dart';

import '../util/boton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  List botones = [
    ["Lugares cercanos", "lib/icons/lugares.png"],
    ["Escanear QR", "lib/icons/qr.png"],
    ["Busqueda por voz", "lib/icons/microfono.png"],
    ["Ver mapa", "lib/icons/mapa.png"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("/images/fondo.jpg"), // Ruta de la imagen de fondo
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // menu icon
                    Image.asset(
                      'lib/icons/menu.png',
                      height: 40,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 80),

              // welcome home
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "¿Qué lugar te gustaria visitar?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 36,
                          color: Colors.white,
                        ),
                      ),
                    ]),
              ),

              const SizedBox(height: 150),

              // smart devices grid

              // grid
              Expanded(
                child: GridView.builder(
                  itemCount: 4,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.3,
                  ),
                  itemBuilder: (context, index) {
                    return Boton(
                      nombre: botones[index][0],
                      icono: botones[index][1],
                    );
                  },
                ),
              )
            ],
          ),
        ),
        // Aquí puedes agregar tus widgets internos
      ),
      backgroundColor: Colors.grey[300],
    );
  }
}
