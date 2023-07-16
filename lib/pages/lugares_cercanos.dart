import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/firebase_services.dart';
import '../util/lugar.dart';

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
    lugaresCercanos =
        List<Lugar>.empty(growable: true); // Inicializar la lista vacía

    getLugaresFromFirebase().then((lugares) {
      setState(() {
        lugaresCercanos = lugares;
        filteredLugares.addAll(lugaresCercanos);
        filterLugares(widget.searchText); // Filtrar los lugares inicialmente
      });
    });
    _searchController.text = widget.searchText; // Establecer el texto de búsqueda inicial
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

  void toggleMarcado(int index) {
    setState(() {
      lugaresCercanos[index].marcado = !lugaresCercanos[index].marcado;
    });
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
          IconButton(
            icon: Image.asset(
              'lib/icons/menu.png', // Reemplaza la ruta con la ubicación de tu imagen
            ),
            iconSize: 35,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30.0), // Establecer un espacio superior
        child: ListView.builder(
          itemCount: filteredLugares.length,
          itemBuilder: (BuildContext context, int index) {
            final lugar = filteredLugares[index];
            return ListTile(
              leading: const Icon(
                  Icons.location_on), // Icono a la izquierda del título
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
                  toggleMarcado(index);
                },
              ),
              // Agrega cualquier otro widget adicional para mostrar información sobre el lugar
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
