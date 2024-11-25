import 'package:flutter/material.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';
import './cotizacion.dart';

class CotizacionCreate extends StatefulWidget {
  @override
  State<CotizacionCreate> createState() => CotizacionCreateState();
}

class CotizacionCreateState extends State<CotizacionCreate> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController ivaController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agregar Cotización',
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.indigo[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: codigoController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Código',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: ivaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'IVA',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: totalController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Total',
              ),
            ),
            SizedBox(height: 20),
            MaterialButton(
              height: 40,
              onPressed: agregarCotizacion,
              child: Text(
                "Agregar Cotización",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              color: Colors.indigo[900],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Productos"),
          BottomNavigationBarItem(icon: Icon(Icons.pageview), label: "Cotizaciones"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Pedidos")
        ]
      ),
    );
  }

  void agregarCotizacion() async {
    try {
      Cotizacion cotizacion = Cotizacion(
        idCotizacion: null, // ID auto-generado
        idEstadoCoti: 1, // Puede ser un valor real según tu lógica
        codigo: codigoController.text,
        iva: double.parse(ivaController.text),
        total: double.parse(totalController.text),
        imagen: '', // Sin imagen
      );

      await firebaseService.createOrUpdateCotizacion(cotizacion);
      Navigator.pop(context);
    } on Exception catch (e) {
      print(e);
    }
  }
}
