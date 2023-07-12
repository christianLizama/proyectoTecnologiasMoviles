import 'package:flutter/material.dart';

class LugaresCercanos extends StatefulWidget {
  const LugaresCercanos({super.key});

  @override
  State<LugaresCercanos> createState() => _LugaresCercanosState();
}

class _LugaresCercanosState extends State<LugaresCercanos> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[700],
        title: TextField(
          controller: _searchController,
          style: const TextStyle(
              color: Colors.white), // Cambia el color del texto a blanco
          decoration: const InputDecoration(
            hintText: 'Buscar',
            border: InputBorder.none,
            hintStyle: TextStyle(
                color: Colors
                    .white70), // Cambia el color del texto de sugerencia a blanco
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Acción del botón de búsqueda
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            icon: Image.asset(
                'lib/icons/menu.png'), // Reemplaza la ruta con la ubicación de tu imagen
            iconSize: 35,
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Lugares cercanos'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
