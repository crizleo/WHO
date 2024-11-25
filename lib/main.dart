import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:who/screens/loginPage.dart';

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
        primarySwatch: Colors.orange, // Tema principal de la app
      ),
      home: LoginPage(), // Página inicial de la aplicación
    );
  }
}

