import 'package:flutter/material.dart';
import 'package:lugares_cercanos/pages/login.dart';
import 'package:lugares_cercanos/pages/register.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
  }

  void navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Regístrate para continuar!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 70),
            SizedBox(
              width: 350, // Ancho personalizado para los botones
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para registrarse con Google
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 223, 223, 223), // Color gris para el botón
                  padding: EdgeInsets.zero, // Sin relleno interno
                  alignment: Alignment
                      .centerLeft, // Alineación del contenido a la izquierda
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
                        padding: EdgeInsets.only(
                          right:
                              30, // Ajuste el padding derecho según sea necesario
                        ),
                        child: Text(
                          'Registrarse con Google',
                          textAlign: TextAlign
                              .center, // Alineación del texto al centro
                          style: TextStyle(
                            color: Colors.black, // Color del texto
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Separacion entre botones
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('o'),
                ),
                Expanded(child: Divider(color: Colors.grey)),
              ],
            ),
            // Boton de registro normal
            const SizedBox(height: 16),
            SizedBox(
              width: 350, // Ancho personalizado para los botones
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para registrarse con email
                  navigateToRegister();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(
                      255, 223, 223, 223), // Color gris para el botón
                  padding: EdgeInsets.zero, // Sin relleno interno
                  alignment:
                      Alignment.center, // Alineación del contenido al centro
                ),
                child: const Text(
                  'Registrarse con Email',
                  style: TextStyle(
                    color: Colors.black, // Color del texto
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Al registrarte, aceptas nuestros',
              style: TextStyle(color: Color.fromARGB(255, 125, 125, 125)),
            ),
            const Text(
              'Términos y Condiciones',
              style: TextStyle(color: Color.fromARGB(255, 125, 125, 125)),
            ),
            const SizedBox(height: 80),
            const Text(
              'Ya tienes una cuenta?',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                navigateToLogin();
              },
              child: const Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 160, 0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
