import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/lugar.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Lugar>> getLugaresFromFirebase() async {
  List<Lugar> lugares = [];

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('lugares').get();

  for (var doc in querySnapshot.docs) {
    String id = doc.id;
    String nombre = doc['nombre'];
    String historia = doc['historia'];
    double valoracion = doc['valoracion'].toDouble();
    List valoraciones = doc['valoraciones'];
    Map ubicacion = doc['ubicacion'];

    Lugar lugar = Lugar(
      id: id,
      nombre: nombre,
      historia: historia,
      valoracion: valoracion,
      valoraciones: valoraciones,
      ubicacion: ubicacion,
    );

    lugares.add(lugar);
  }

  return lugares;
}

Future<Lugar?> getLugarByNameFromFirebase(String nombreLugar) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('lugares')
      .where('nombre', isEqualTo: nombreLugar)
      .limit(1)
      .get();

  if (querySnapshot.docs.isNotEmpty) {
    var doc = querySnapshot.docs.first;
    String id = doc.id;
    String nombre = doc['nombre'];
    String historia = doc['historia'];
    double valoracion = doc['valoracion'].toDouble();
    List valoraciones = doc['valoraciones'];
    Map ubicacion = doc['ubicacion'];

    Lugar lugar = Lugar(
      id: id,
      nombre: nombre,
      historia: historia,
      valoracion: valoracion,
      valoraciones: valoraciones,
      ubicacion: ubicacion,
    );

    return lugar;
  }
  return null;
}
