import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../services/firebaseDataBase.dart';
import '../../models/modelCotizacion.dart';
import './cotizacionUpdate.dart';
import './cotizacionInsert.dart';

class CotizacionList extends StatefulWidget {
  @override
  State<CotizacionList> createState() => CotizacionListState();
}

class CotizacionListState extends State<CotizacionList> {
  FirebaseService firebaseService = FirebaseService();
  List<Cotizacion> cotizaciones = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarCotizaciones();
  }

  Future<void> cargarCotizaciones() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      DatabaseEvent event = await FirebaseDatabase.instance
          .ref()
          .child('cotizaciones')
          .once();
      
      DataSnapshot snapshot = event.snapshot;
      
      if (snapshot.value != null) {
        Map<String, dynamic> cotizacionesMap = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          cotizaciones = cotizacionesMap.entries.map((entry) {
            Map<String, dynamic> cotizacionData = Map<String, dynamic>.from(entry.value as Map);
            return Cotizacion.fromJson(cotizacionData);
          }).toList();
          // Ordenar por código de manera descendente (más reciente primero)
          cotizaciones.sort((a, b) => b.codigo.compareTo(a.codigo));
        });
      } else {
        setState(() {
          cotizaciones = [];
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error al cargar las cotizaciones: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _confirmarEliminacion(BuildContext context, Cotizacion cotizacion) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Está seguro que desea eliminar la cotización ${cotizacion.codigo}?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await firebaseService.deleteCotizacion(cotizacion.idCotizacion!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cotización eliminada con éxito'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  cargarCotizaciones();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error al eliminar la cotización: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Cotizaciones', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarCotizaciones,
          ),
          IconButton(
            icon: const Icon(Icons.add),
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