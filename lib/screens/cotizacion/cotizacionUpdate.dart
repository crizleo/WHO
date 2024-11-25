import 'package:flutter/material.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';

class CotizacionUpdate extends StatefulWidget {
  final int cotizacionId;

  CotizacionUpdate({required this.cotizacionId});

  @override
  State<CotizacionUpdate> createState() => CotizacionUpdateState();
}

class CotizacionUpdateState extends State<CotizacionUpdate> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController nombreClienteController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController ivaController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  Cotizacion? cotizacion;

  @override
  void initState() {
    super.initState();
    cargarCotizacion();
  }

  void cargarCotizacion() async {
    cotizacion = await firebaseService.readCotizacion(widget.cotizacionId);
    setState(() {
      codigoController.text = cotizacion?.codigo ?? '';
      nombreClienteController.text = cotizacion?.nombreCliente ?? '';
      fechaController.text = cotizacion?.fecha ?? '';
      ivaController.text = cotizacion?.iva.toString() ?? '';
      totalController.text = cotizacion?.total.toString() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Actualizar Cotización',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  height: 40,
                  onPressed: actualizarCotizacion,
                  child: Text(
                    "Actualizar Cotización",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  color: Colors.indigo[900],
                ),
                MaterialButton(
                  height: 40,
                  onPressed: eliminarCotizacion,
                  child: Text(
                    "Eliminar Cotización",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  color: Colors.red[900],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void actualizarCotizacion() async {
    try {
      if (cotizacion != null) {
        cotizacion = Cotizacion(
          idCotizacion: widget.cotizacionId,
          idEstadoCoti: cotizacion!.idEstadoCoti, // Mantener el estado actual
          codigo: codigoController.text,
          nombreCliente: nombreClienteController.text,
          fecha: fechaController.text,
          iva: double.parse(ivaController.text),
          total: double.parse(totalController.text),
          imagen: cotizacion!.imagen, // Mantener la imagen actual
        );

        await firebaseService.createOrUpdateCotizacion(cotizacion!);
        Navigator.pop(context);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void eliminarCotizacion() async {
    try {
      await firebaseService.deleteCotizacion(widget.cotizacionId);
      Navigator.pop(context);
    } on Exception catch (e) {
      print(e);
    }
  }
}
