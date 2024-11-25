import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';
import './cotizacionUpdate.dart';
import './cotizacionInsert.dart'; // Importar la pantalla de creación de cotización

class CotizacionList extends StatefulWidget {
  @override
  State<CotizacionList> createState() => CotizacionListState();
}

class CotizacionListState extends State<CotizacionList> {
  FirebaseService firebaseService = FirebaseService();
  List<Cotizacion> cotizaciones = [];

  @override
  void initState() {
    super.initState();
    cargarCotizaciones();
  }

  void cargarCotizaciones() async {
    DatabaseEvent event = await FirebaseDatabase.instance.ref().child('cotizaciones').once();
    DataSnapshot snapshot = event.snapshot;
    if (snapshot.value != null) {
      Map<String, dynamic> cotizacionesMap = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        cotizaciones = cotizacionesMap.entries.map((entry) {
          Map<String, dynamic> cotizacionData = Map<String, dynamic>.from(entry.value as Map);
          return Cotizacion.fromJson(cotizacionData);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Cotizaciones'),
        backgroundColor: Colors.indigo[900],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CotizacionCreate()),
              ).then((value) => cargarCotizaciones());
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: cotizaciones.length,
        itemBuilder: (context, index) {
          final cotizacion = cotizaciones[index];
          return ListTile(
            title: Text(cotizacion.codigo),
            subtitle: Text('Cliente: ${cotizacion.nombreCliente}\nFecha: ${cotizacion.fecha}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CotizacionUpdate(cotizacionId: cotizacion.idCotizacion!),
                ),
              ).then((value) => cargarCotizaciones());
            },
          );
        },
      ),
    );
  }
}
