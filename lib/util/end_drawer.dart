import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EndDrawer extends StatelessWidget {
  const EndDrawer({
    Key? key,
    required this.user,
    required this.onSignOutPressed,
  }) : super(key: key);

  final User? user;
  final VoidCallback onSignOutPressed;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(150, 255, 255, 255),
          ),
          child: ListView(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.05),
            children: <Widget>[
              ListTile(
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 5),
                      Text(user?.displayName ?? 'Nombre de usuario'),
                    ],
                  ),
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
                  child: Text('Busqueda por voz'),
                ),
                onTap: () {
                  // Agrega el código para la opción
                  Navigator.pushNamed(context, '/busquedaVoz');
                },
              ),
              ListTile(
                title: const Center(
                  child: Text('Ver mapa'),
                ),
                onTap: () {
                  // Agrega el código para la opción
                  Navigator.pushNamed(context, '/verMapa');
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
                onPressed: onSignOutPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(10, 50),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
