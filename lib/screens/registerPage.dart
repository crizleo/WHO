import 'package:flutter/material.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'loginPage.dart';

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