import 'package:flutter/material.dart';
import '../services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Bienvenido!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Inicia sesión para continuar!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 350,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para iniciar sesión con Google
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 223, 223, 223),
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        'assets/images/googlebtn.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          'Iniciar sesión con Google',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'O',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ======== Email ========
                    TextFormField(
                      key: const ValueKey('email'),
                      decoration: InputDecoration(
                        hintText: 'Ingrese su Email',
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.amber),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .amber), // Color del borde cuando está enfocado
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      style: TextStyle(color: Colors.black), // Color del texto
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Por favor ingrese un Email válido';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          email = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // ======== Password ========
                    TextFormField(
                      key: const ValueKey('password'),
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Ingrese Contraseña',
                        prefixIcon: const Icon(Icons.lock, color: Colors.amber),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors
                                  .amber), // Color del borde cuando está enfocado
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.amber),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.length < 6) {
                          return 'Por favor ingrese una clave que tenga un mínimo de 6 caracteres';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            AuthServices.signinUser(email, password, context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[
                              700], // Aquí se establece el color amber[700]
                        ),
                        child: const Text('Iniciar Sesión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
