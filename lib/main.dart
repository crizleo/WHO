import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  // Inicializa Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Authentication Example', // Título de la app
      theme: ThemeData(
        primarySwatch: Colors.blue, // Tema principal de la app
      ),
      home: LoginPage(), // Página inicial de la aplicación
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(); // Controlador para el campo de correo
  final TextEditingController passwordController = TextEditingController(); // Controlador para el campo de contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'), // Título de la barra superior
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo de entrada para el correo electrónico
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'), // Etiqueta para el campo de correo
              ),
              // Campo de entrada para la contraseña
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'), // Etiqueta para el campo de contraseña
                obscureText: true, // Para ocultar el texto en el campo de contraseña
              ),
              SizedBox(height: 16), // Espacio en blanco
              // Botón para iniciar sesión
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Intenta iniciar sesión con Firebase
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    // Inicio de sesión exitoso, navega a la página de "Hola Mundo"
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HelloWorldPage()),
                    );
                  } catch (e) {
                    // Error de inicio de sesión, muestra un mensaje de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Correo electrónico o contraseña incorrectos'), // Mensaje de error en la interfaz
                      ),
                    );
                    print('Error de inicio de sesión: $e'); // Imprime el error en la consola
                  }
                },
                child: Text('Iniciar Sesión'), // Texto del botón de inicio de sesión
              ),
              SizedBox(height: 8), // Espacio en blanco
              // Botón para navegar a la página de registro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Text('Registrarse'), // Texto del botón de registro
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController(); // Controlador para el campo de correo
  final TextEditingController passwordController = TextEditingController(); // Controlador para el campo de contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'), // Título de la barra superior
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Campo de entrada para el correo electrónico
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Correo electrónico'), // Etiqueta para el campo de correo
              ),
              // Campo de entrada para la contraseña
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'), // Etiqueta para el campo de contraseña
                obscureText: true, // Para ocultar el texto en el campo de contraseña
              ),
              SizedBox(height: 16), // Espacio en blanco
              // Botón para registrar una nueva cuenta
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Intenta registrar una nueva cuenta con Firebase
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                    // Registro exitoso, navega a la página de inicio de sesión
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  } catch (e) {
                    // Error de registro, muestra un mensaje de error
                    print('Error de registro: $e'); // Imprime el error en la consola
                  }
                },
                child: Text('Registrarse'), // Texto del botón de registro
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HelloWorldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Hola Mundo!'), // Título de la barra superior
      ),
      body: Center(
        child: Text('¡Bienvenido! Has iniciado sesión con éxito.'), // Mensaje de bienvenida
      ),
    );
  }
}

