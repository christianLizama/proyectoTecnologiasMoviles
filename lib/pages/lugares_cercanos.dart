import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Lugar {
  final String nombre;
  final String descripcion;
  double calificacion;
  bool marcado;

  Lugar({
    required this.nombre,
    required this.descripcion,
    required this.calificacion,
    this.marcado = false,
  });
}

class LugaresCercanos extends StatefulWidget {
  const LugaresCercanos({Key? key}) : super(key: key);

  @override
  State<LugaresCercanos> createState() => _LugaresCercanosState();
}

class _LugaresCercanosState extends State<LugaresCercanos> {
  final TextEditingController _searchController = TextEditingController();
  List<Lugar> lugaresCercanos = [
    Lugar(
      nombre: 'Plaza de armas',
      descripcion: 'plaza qla',
      calificacion: 4.5,
    ),
    Lugar(
      nombre: 'Lugar 2',
      descripcion: 'Descripción del Lugar 2',
      calificacion: 3.8,
    ),
    Lugar(
      nombre: 'Lugar 3',
      descripcion: 'Descripción del Lugar 3',
      calificacion: 4.2,
    ),
    Lugar(
      nombre: 'Lugar 4',
      descripcion: 'Descripción del Lugar 4',
      calificacion: 4.7,
    ),
    Lugar(
      nombre: 'Lugar 5',
      descripcion: 'Descripción del Lugar 5',
      calificacion: 4.1,
    ),
  ];
  List<Lugar> filteredLugares = [];

  @override
  void initState() {
    filteredLugares.addAll(lugaresCercanos);
    super.initState();
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
      body: ListView.builder(
        itemCount: filteredLugares.length,
        itemBuilder: (BuildContext context, int index) {
          final lugar = filteredLugares[index];
          return ListTile(
            leading: Icon(Icons.location_on), // Icono a la izquierda del título
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
                      rating: lugar.calificacion,
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
                      lugar.calificacion.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  lugar.descripcion,
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
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
