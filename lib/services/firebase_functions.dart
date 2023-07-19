import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static saveUser(String name, email, uid) async {
    Map<String, dynamic> favorites = {}; // Inicializar el mapa de favoritos como vacío

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'email': email, 'nombre': name, 'favoritos': favorites});
  }
}