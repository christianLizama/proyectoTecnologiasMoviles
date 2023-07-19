import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/firebase_services.dart';
import '../util/lugar.dart';
import 'vista_lugar.dart';
import '../util/end_drawer.dart'; // Importa el componente EndDrawer
import '../services/auth.dart'; // Importa el servicio de autenticación

class LugaresCercanos extends StatefulWidget {
  final String searchText;
  const LugaresCercanos({Key? key, required this.searchText}) : super(key: key);

  @override
  State<LugaresCercanos> createState() => _LugaresCercanosState();
}

class _LugaresCercanosState extends State<LugaresCercanos> {
  final TextEditingController _searchController = TextEditingController();
  List<Lugar> lugaresCercanos = [];
  List<Lugar> filteredLugares = [];

  @override
  void initState() {
    super.initState();
    lugaresCercanos = List<Lugar>.empty(growable: true);

    getUserId().then((userId) {
      if (userId != null) {
        // Obtener los lugares cercanos
        getLugaresFromFirebase().then((lugares) {
          setState(() {
            lugaresCercanos = lugares;
            filteredLugares.addAll(lugaresCercanos);
            filterLugares(
                widget.searchText); // Filtrar los lugares inicialmente

            // Obtener los lugares favoritos del usuario
            getFavoritosUsuario(userId).then((favoritos) {
              for (var lugar in lugaresCercanos) {
                setState(() {
                  lugar.marcado = favoritos.contains(lugar.id);
                });
              }
            });
          });
        });
      }
    });
    _searchController.text =
        widget.searchText; // Establecer el texto de búsqueda inicial
  }

  void filterLugares(String searchText) {
    filteredLugares.clear();
    if (searchText.isEmpty) {
      filteredLugares.addAll(lugaresCercanos);
    } else {
      filteredLugares.addAll(lugaresCercanos.where((lugar) =>
          lugar.nombre.toLowerCase().contains(searchText.toLowerCase())));
    }
    setState(() {});
  }

  Future<String?> getUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      return userId;
    } else {
      return null;
    }
  }

  void toggleMarcado(String lugarId) async {
    final lugar = lugaresCercanos.firstWhere((lugar) => lugar.id == lugarId);
    final lugarNombre = lugar.nombre;

    String? userId = await getUserId();
    if (userId != null) {
      try {
        if (lugar.marcado) {
          // Eliminar el lugar de la lista de favoritos
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({
            'favoritos.$lugarId': FieldValue.delete(),
          });
        } else {
          // Agregar el lugar a la lista de favoritos
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({
            'favoritos.$lugarId.id': lugarId,
            'favoritos.$lugarId.nombre': lugarNombre,
          });
        }
        setState(() {
          lugar.marcado = !lugar.marcado;
        });
      } catch (e) {
        print('Error al actualizar la lista de favoritos: $e');
      }
    } else {
      print('No hay usuario loggeado');
    }
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
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          onChanged: filterLugares,
          decoration: const InputDecoration(
            hintText: 'Buscar',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              filterLugares(_searchController.text);
            },
            icon: const Icon(Icons.search),
          ),
          Builder(
            builder: (BuildContext context) {
              // Utiliza Builder para crear un nuevo contexto vinculado al Scaffold
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
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView.builder(
          itemCount: filteredLugares.length,
          itemBuilder: (BuildContext context, int index) {
            final lugar = filteredLugares[index];
            return ListTile(
              leading: const Icon(Icons.location_on),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lugar.nombre,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: lugar.valoracion,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 20,
                        unratedColor: Colors.grey[300],
                        direction: Axis.horizontal,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        lugar.valoracion.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '(${lugar.valoraciones.length})',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    lugar.historia.length > 125
                        ? '${lugar.historia.substring(0, 125)}...'
                        : lugar.historia,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  lugar.marcado ? Icons.favorite : Icons.favorite_border,
                  color: lugar.marcado ? Colors.red : null,
                ),
                onPressed: () {
                  toggleMarcado(lugar.id);
                },
              ),
              onTap: () {
                navigateToLugarDetalle(
                    lugar); // Navegar a la vista de detalles del lugar
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
