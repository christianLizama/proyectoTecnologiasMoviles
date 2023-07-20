import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EndDrawer extends StatelessWidget {
  final String? _vistaPrevia;

  const EndDrawer({
    Key? key,
    required this.user,
    required this.onSignOutPressed,
    String? vistaPrevia,
  })  : _vistaPrevia = vistaPrevia,
        super(key: key);

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
              if (_vistaPrevia != '/lugaresCercanos')
                ListTile(
                  title: const Center(
                    child: Text('Lugares cercanos'),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/lugaresCercanos',
                        arguments: '/lugaresCercanos');
                  },
                ),
              if (_vistaPrevia != '/escanearQR')
                ListTile(
                  title: const Center(
                    child: Text('Escanear QR'),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/escanearQR',
                        arguments: '/escanearQR');
                  },
                ),
              if (_vistaPrevia != '/busquedaVoz')
                ListTile(
                  title: const Center(
                    child: Text('Búsqueda por voz'),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/busquedaVoz',
                        arguments: '/busquedaVoz');
                  },
                ),
              if (_vistaPrevia != '/verMapa')
                ListTile(
                  title: const Center(
                    child: Text('Ver mapa'),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/verMapa',
                        arguments: '/verMapa');
                  },
                ),
              if (_vistaPrevia != '/favoritos')
                ListTile(
                  title: const Center(
                    child: Text('Favoritos'),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/favoritos',
                        arguments: '/favoritos');
                  },
                ),
              if (_vistaPrevia != '/addLugar')
                ListTile(
                  title: const Center(
                    child: Text('Agregar Lugar'),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/addLugar',
                        arguments: '/addLugar');
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
