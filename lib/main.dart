import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:who/screens/loginPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Authentication Example',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      // Agregar la configuración de localización aquí
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', ''),
      ],
      home: LoginPage(),
    );
  }
}