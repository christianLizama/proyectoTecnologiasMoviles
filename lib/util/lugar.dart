class Lugar {
  final String id;
  final String nombre;
  final String historia;
  double valoracion;
  List valoraciones;
  Map ubicacion;
  bool marcado;

  Lugar({
    required this.id,
    required this.nombre,
    required this.historia,
    required this.valoracion,
    required this.valoraciones,
    required this.ubicacion,
    this.marcado = false,
  });

  void printValues() {
    print('Id: $id');
    print('Nombre: $nombre');
    print('Historia: $historia');
    print('Valoración: $valoracion');
    print('Valoraciones: $valoraciones');
    print('Ubicación: $ubicacion');
    print('Marcado: $marcado');
  }
}
