import 'package:cloud_firestore/cloud_firestore.dart';
import '../util/lugar.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> updateFavoriteInDatabase(
    String userId, String lugarId, bool isFavorite, String nombreLugar) async {
  try {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> favoritos =
          Map<String, dynamic>.from(docSnapshot.get('favoritos'));

      if (isFavorite) {
        favoritos[lugarId] = {
            'id': lugarId,
            'nombre': nombreLugar,
        };
      } else {
        // Eliminar el lugar de la lista de favoritos
        favoritos.remove(lugarId);
      }

      await docRef.update({'favoritos': favoritos});
    }
  } catch (e) {
    print('Error al actualizar los favoritos del usuario: $e');
  }
}

Future<List<String>> getFavoritosUsuario(String userId) async {
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null && data['favoritos'] != null) {
        final favoritos = Map<String, dynamic>.from(data['favoritos']);
        return favoritos.keys.toList();
      }
    }
  } catch (e) {
    print('Error al obtener los favoritos del usuario: $e');
  }

  return [];
}

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
