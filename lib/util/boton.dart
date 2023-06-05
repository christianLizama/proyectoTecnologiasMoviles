import 'package:flutter/material.dart';

class Boton extends StatelessWidget {
  final String nombre;
  final String icono;

  const Boton({
    super.key,
    required this.nombre,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[400]?.withOpacity(0.4),
            borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // smart device name + switch
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        nombre,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  icono,
                  height: 55,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
