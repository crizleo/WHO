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

      DatabaseEvent event =
          await FirebaseDatabase.instance.ref().child('cotizaciones').once();

      if (event.snapshot.value != null) {
        print('Datos crudos: ${event.snapshot.value}'); // Debug

        Map<dynamic, dynamic> data =
            event.snapshot.value as Map<dynamic, dynamic>;
        List<Cotizacion> listaCotizaciones = [];

        data.forEach((key, value) {
          try {
            // Convertir todos los valores a String, dynamic
            Map<String, dynamic> cotizacionMap = {};
            (value as Map<dynamic, dynamic>).forEach((k, v) {
              if (k.toString() == 'items' && v != null) {
                // Convertir items a List<Map<String, dynamic>>
                List<Map<String, dynamic>> itemsList = [];

                if (v is Map) {
                  v.forEach((itemKey, itemValue) {
                    if (itemValue is Map) {
                      Map<String, dynamic> itemMap =
                          _convertToStringDynamicMap(itemValue);
                      itemMap['id'] = itemKey
                          .toString(); // Asegurar que el id está presente
                      itemsList.add(itemMap);
                    }
                  });
                } else if (v is List) {
                  for (var item in v) {
                    if (item is Map) {
                      Map<String, dynamic> itemMap =
                          _convertToStringDynamicMap(item);
                      itemsList.add(itemMap);
                    }
                  }
                }

                cotizacionMap['items'] = itemsList;
              } else {
                cotizacionMap[k.toString()] = v;
              }
            });

            // Agregar el ID de la cotización
            cotizacionMap['idCotizacion'] = key;

            Cotizacion cotizacion = Cotizacion.fromJson(cotizacionMap);
            listaCotizaciones.add(cotizacion);
          } catch (e, stackTrace) {
          }
        });

        setState(() {
          cotizaciones = listaCotizaciones;
          cotizaciones.sort((a, b) => b.codigo.compareTo(a.codigo));
        });

      } else {
        setState(() {
          cotizaciones = [];
        });
      }
    } catch (e, stackTrace) {
      setState(() {
        error = 'Error al cargar las cotizaciones: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Función auxiliar para convertir Map<dynamic, dynamic> a Map<String, dynamic>
  Map<String, dynamic> _convertToStringDynamicMap(Map<dynamic, dynamic> map) {
    Map<String, dynamic> result = {};
    map.forEach((key, value) {
      if (value is Map) {
        result[key.toString()] = _convertToStringDynamicMap(value);
      } else if (value is List) {
        result[key.toString()] = value.map((item) {
          if (item is Map) {
            return _convertToStringDynamicMap(item);
          }
          return item;
        }).toList();
      } else {
        result[key.toString()] = value;
      }
    });
    return result;
  }

  Future<void> _confirmarEliminacion(
      BuildContext context, Cotizacion cotizacion) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
              '¿Está seguro que desea eliminar la cotización ${cotizacion.codigo}?'),
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
                  await firebaseService
                      .deleteCotizacion(cotizacion.idCotizacion!);
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
        title: const Text(
          'Cotizaciones',
          style: TextStyle(color: Colors.white),
        ),
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
      body: RefreshIndicator(
        onRefresh: cargarCotizaciones,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: cargarCotizaciones,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : cotizaciones.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.description_outlined,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay cotizaciones disponibles',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: cotizaciones.length,
                        itemBuilder: (context, index) {
                          final cotizacion = cotizaciones[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Text(
                                  cotizacion.codigo,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                'Cotización ${cotizacion.codigo}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    'Total: \$${cotizacion.total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.indigo),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CotizacionUpdate(
                                                  cotizacionId:
                                                      cotizacion.idCotizacion!),
                                        ),
                                      ).then((value) => cargarCotizaciones());
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _confirmarEliminacion(
                                        context, cotizacion),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
