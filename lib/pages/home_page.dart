import 'package:flutter/material.dart';

import '../util/boton.dart';

final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

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
    ["Lugares cercanos", "lib/icons/lugares.png", '/lugaresCercanos'],
    ["Escanear QR", "lib/icons/qr.png", '/escanearQR'],
    ["Busqueda por voz", "lib/icons/microfono.png", '/busquedaVoz'],
    ["Ver mapa", "lib/icons/mapa.png", '/verMapa'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        shadowColor: const Color.fromARGB(0, 244, 67, 54),
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Image.asset(
                    'lib/icons/menu.png'), // Reemplaza la ruta con la ubicación de tu imagen
                iconSize: 35,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Establece la transparencia aquí
          canvasColor: Colors
              .transparent, // o cualquier otro color que desees, por ejemplo, Colors.blue.withOpacity(0.5)
        ),
        child: Drawer(
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(150, 255, 255,
                  255), // Establece el color de fondo como transparente
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              children: <Widget>[
                ListTile(
                  title: const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person), // Icono de usuario
                        SizedBox(width: 5), // Espacio entre el icono y el texto
                        Text('Nombre de usuario'),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Agrega el código para la opción
                  },
                ),
                //agregar linea de separacion
                const Divider(
                  color: Color.fromARGB(150, 255, 255, 255),
                  height: 20,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                ListTile(
                  title: const Center(
                    child: Text('Lugares cercanos'),
                  ),
                  onTap: () {
                    // Agrega el código para la opción
                    Navigator.pushNamed(context, '/lugaresCercanos');
                  },
                ),
                ListTile(
                  title: const Center(
                    child: Text('Escanear QR'),
                  ),
                  onTap: () {
                    // Agrega el código para la opción
                    Navigator.pushNamed(context, '/escanearQR');
                  },
                ),
                ListTile(
                  title: const Center(
                    child: Text('Favoritos'),
                  ),
                  onTap: () {
                    // Agrega el código para la opción
                  },
                ),
                const Divider(
                  color: Color.fromARGB(150, 255, 255, 255),
                  height: 20,
                  thickness: 2,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    // Agrega el código para cerrar la sesión aquí
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Color de fondo celeste
                    //borde al boton
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    //ancho del boton
                    minimumSize: const Size(10, 50),
                  ),
                  icon: Icon(Icons.logout), // Icono de salir/cerrar sesión
                  label: Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        ),
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
                      ruta: botones[index][2],
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
