import 'package:flutter/material.dart';
import '../util/lugar.dart';

class LugarDetalle extends StatelessWidget {
  final Lugar lugar;

  const LugarDetalle({Key? key, required this.lugar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del lugar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              lugar.nombre,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              lugar.historia,
              style: const TextStyle(fontSize: 16),
            ),
            // Agrega cualquier otro widget adicional para mostrar más detalles del lugar
          ],
        ),
      ),
    );
  }
}