import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/modelProducto.dart';
import '../../services/firebaseDataBase.dart';

class SelectorProducto extends StatefulWidget {
  @override
  _SelectorProductoState createState() => _SelectorProductoState();
}

class _SelectorProductoState extends State<SelectorProducto> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Producto> productos = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    try {
      final listaProductos = await _firebaseService.getProductos();
      setState(() {
        productos = listaProductos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar productos: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Producto> _filtrarProductos() {
    if (searchQuery.isEmpty) return productos;
    return productos.where((producto) =>
      producto.nombre.toLowerCase().contains(searchQuery.toLowerCase()) ||
      producto.codigo.toString().contains(searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productosFiltrados = _filtrarProductos();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seleccionar Producto',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: productosFiltrados.length,
                    itemBuilder: (context, index) {
                      final producto = productosFiltrados[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(producto.imagen),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          title: Text(producto.nombre),
                          subtitle: Text(
                            NumberFormat.currency(
                              locale: 'es_CO',
                              symbol: '\$',
                            ).format(producto.precio),
                          ),
                          trailing: const Icon(Icons.add_circle_outline),
                          onTap: () {
                            Navigator.pop(context, producto);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}