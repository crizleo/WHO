import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebaseDataBase.dart';
import '../models/modelProducto.dart';
import 'loginPage.dart'; // Asegúrate de importar LoginPage

class HomeScreen extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
        title: Text('Firebase Realtime Database Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Producto producto = Producto(
                  codigo: 1,
                  nombre: 'Producto A',
                  precio: 100,
                  descripcion: 'Descripción del producto A',
                  imagen: 'imagen_url',
                );
                firebaseService.createOrUpdateProducto(producto);
              },
              child: Text('Crear/Actualizar Producto'),
            ),
            ElevatedButton(
              onPressed: () async {
                Producto producto = await firebaseService.readProducto(1);
                print('Producto: ${producto.nombre}');
              },
              child: Text('Leer Producto'),
            ),
            ElevatedButton(
              onPressed: () {
                firebaseService.deleteProducto(1);
              },
              child: Text('Eliminar Producto'),
            ),
          ],
        ),
      ),
      
    );

  }
}
