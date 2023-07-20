import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AgregarLugarScreen extends StatefulWidget {
  const AgregarLugarScreen({Key? key}) : super(key: key);

  @override
  State<AgregarLugarScreen> createState() => _AgregarLugarScreenState();
}

class _AgregarLugarScreenState extends State<AgregarLugarScreen> {
  final _formKey = GlobalKey<FormState>();
  String historia = '';
  String nombre = '';
  double latitud = 0.0;
  double longitud = 0.0;
  double valoracion = 0.0;
  List<String> valoraciones = [];
  List<File?> _images = [];

  // Esta función maneja el SnackBar sin referencia directa al BuildContext
  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  // Esta función permite seleccionar múltiples imágenes de la galería
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 85);
    setState(() {
      _images =
          pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
  }

  // Esta función sube las imágenes seleccionadas a Firebase Storage y devuelve las URLs
  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      for (int i = 0; i < _images.length; i++) {
        final fileName =
            'lugares/${DateTime.now().millisecondsSinceEpoch}-$i.jpg';
        final storageRef = FirebaseStorage.instance.ref().child(fileName);

        final uploadTask = await storageRef.putFile(_images[i]!);
        final downloadUrl = await uploadTask.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      return imageUrls;
    } catch (e) {
      print('Error uploading images: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Lugar'),
        backgroundColor: Colors.amber[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Historia'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa la historia';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    historia = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa el nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    nombre = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Latitud'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa la latitud';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    latitud = double.tryParse(value!) ?? 0.0;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Longitud'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Por favor, ingresa la longitud';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    longitud = double.tryParse(value!) ?? 0.0;
                  },
                ),
                ElevatedButton(
                    onPressed: _pickImages,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                    ),
                    child: const Text('Seleccionar Imágenes')),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        DocumentSnapshot<Map<String, dynamic>> userSnapshot =
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .get();

                        Map<String, dynamic>? userData = userSnapshot.data();
                        if (userData != null && userData['role'] == 'admin') {
                          // Subir las imágenes a Firebase Storage y obtener las URLs
                          List<String> imageUrls = await _uploadImages();

                          // Agregar el lugar a Firestore con las URLs de las imágenes
                          FirebaseFirestore.instance.collection('lugares').add({
                            'historia': historia,
                            'nombre': nombre,
                            'ubicacion': {
                              'latitud': latitud,
                              'longitud': longitud,
                            },
                            'valoracion': valoracion,
                            'valoraciones': valoraciones,
                            'imagenes': imageUrls,
                          });

                          // Mostrar un mensaje de éxito y regresar a la pantalla anterior
                          _mostrarSnackBar('Lugar agregado con éxito');

                          // Limpiar los campos de texto y la lista de imágenes después de agregar el lugar
                          setState(() {
                            historia = '';
                            nombre = '';
                            latitud = 0.0;
                            longitud = 0.0;
                            valoracion = 0.0;
                            valoraciones = [];
                            _images = [];
                          });
                        } else {
                          _mostrarSnackBar(
                              'No tienes permiso para agregar lugares');
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[700],
                  ),
                  child: const Text('Agregar Lugar'),
                ),
                Column(
                  children: _images.map((image) {
                    return image != null
                        ? Image.file(
                            image,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          )
                        : Container();
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
