import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth.dart';
import '../services/firebase_services.dart';
import '../util/end_drawer.dart';
import '../util/lugar.dart';
import 'vista_lugar.dart';

class MisFavoritos extends StatefulWidget {
  const MisFavoritos({Key? key}) : super(key: key);

  @override
  State<MisFavoritos> createState() => _MisFavoritosState();
}

class _MisFavoritosState extends State<MisFavoritos> {
  late User _user;
  List<Lugar> _favoritos = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _getFavoritos();
  }

  void _getFavoritos() async {
    List<String> favoritosIds = await getFavoritosUsuario(_user.uid);
    List<Lugar> lugares = await getLugaresFromFirebase();

    List<Lugar> favoritos =
        lugares.where((lugar) => favoritosIds.contains(lugar.id)).toList();

    setState(() {
      _favoritos = favoritos;
    });
  }

  void navigateToLugarDetalle(Lugar lugar) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LugarDetalle(lugar: lugar),
      ),
    );

    if (result != null && result is bool) {
      // Actualizar la lista de lugares cercanos en función del estado de isFavorite
      setState(() {
        lugar.marcado = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: const Text("Mis favoritos"),
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
      body: ListView.builder(
        itemCount: _favoritos.length,
        itemBuilder: (BuildContext context, int index) {
          final lugar = _favoritos[index];
          return ListTile(
            leading: const Icon(Icons.location_on),
            title: Text(
              lugar.nombre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              lugar.historia,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              navigateToLugarDetalle(lugar);
            },
          );
        },
      ),
    );
  }
}
