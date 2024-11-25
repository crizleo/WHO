import 'package:flutter/material.dart';

class HelloWorldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('¡Hola Mundo!'), // Título de la barra superior
      ),
      body: const Center(
        child: Text('¡Bienvenido! Has iniciado sesión con éxito.'), // Mensaje de bienvenida
      ),
    );
  }
}