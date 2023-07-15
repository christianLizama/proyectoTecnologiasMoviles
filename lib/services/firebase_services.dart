import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/lugar.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Lugar>> getLugaresFromFirebase() async {
  List<Lugar> lugares = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('lugares').get();

  querySnapshot.docs.forEach((doc) {
    String nombre = doc['nombre'];
    String historia = doc['historia'];
    double valoracion = doc['valoracion'].toDouble();
    List valoraciones = doc['valoraciones'];
    Map ubicacion = doc['ubicacion'];

    print(doc['ubicacion']);

    Lugar lugar = Lugar(
      nombre: nombre,
      historia: historia,
      valoracion: valoracion,
      valoraciones: valoraciones,
      ubicacion: ubicacion,
    );

    lugares.add(lugar);
  });

  return lugares;
}
