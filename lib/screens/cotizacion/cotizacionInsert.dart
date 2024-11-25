import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';
import './cotizacionUpdate.dart'; // Importar la pantalla de actualización de cotización

class CotizacionCreate extends StatefulWidget {
  @override
  State<CotizacionCreate> createState() => CotizacionCreateState();
}

class CotizacionCreateState extends State<CotizacionCreate> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreClienteController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController ivaController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
              controller: nombreClienteController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Nombre del Cliente',
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: fechaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Fecha',
              ),
              onTap: () async { 
                DateTime? pickedDate = await showDatePicker( 
                  context: context, 
                  initialDate: selectedDate, 
                  firstDate: DateTime(2000), 
                  lastDate: DateTime(2101), 
                ); 
                if (pickedDate != null && pickedDate != selectedDate) { 
                  setState(() { 
                    selectedDate = pickedDate; 
                    fechaController.text = DateFormat('yyyy-MM-dd').format(selectedDate); 
                  }); 
                } 
              },
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
    );
  }

  void agregarCotizacion() async {
    try {
      Cotizacion cotizacion = Cotizacion(
        idCotizacion: DateTime.now().millisecondsSinceEpoch, // Generar un ID basado en la hora actual
        idEstadoCoti: 1, // Puede ser un valor real según tu lógica
        codigo: codigoController.text,
        nombreCliente: nombreClienteController.text,
        fecha: selectedDate,
        iva: double.parse(ivaController.text),
        total: double.parse(totalController.text),
        imagen: '', // Sin imagen
      );

      await firebaseService.createOrUpdateCotizacion(cotizacion);

      // Redirigir a la pantalla de actualización de la cotización
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CotizacionUpdate(cotizacionId: cotizacion.idCotizacion!),
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
