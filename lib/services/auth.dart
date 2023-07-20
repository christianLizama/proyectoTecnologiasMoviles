import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import 'firebase_functions.dart' show FirestoreServices;
import '../pages/login.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    final completer = Completer();
    completer.future.then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registro exitoso')));
      signinUser(email, password,
          context); // Realiza el inicio de sesión automáticamente después del registro exitoso
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      await FirestoreServices.saveUser(name, email, userCredential.user!.uid);

      completer.complete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La contraseña es muy débil')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('El email ya está en uso')));
      }

      completer.completeError(e);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));

      completer.completeError(e);
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    final completer = Completer();
    completer.future.then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      completer.complete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'No se han encontrado usuarios con ese correo electrónico')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('La contraseña es incorrecta')));
      }

      completer.completeError(e);
    }
  }

  static signOut(BuildContext context) async {
    final completer = Completer();
    completer.future.then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cierre de sesión exitoso')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const LoginPage(), // Reemplaza "LoginPage" por la página de inicio de sesión correspondiente
        ),
      );
    });

    try {
      await FirebaseAuth.instance.signOut();
      completer.complete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cerrar sesión')));
      completer.completeError(e);
    }
  }
}
