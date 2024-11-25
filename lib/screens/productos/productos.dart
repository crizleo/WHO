import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:who/models/modelProducto.dart';
import 'package:who/screens/productos/productoInsert.dart';



class Productos extends StatefulWidget {
  const Productos({Key? key}) : super(key: key);

  @override
  ProductosState createState() => ProductosState();
}

class ProductosState extends State<Productos> {
  List<Producto> productos = [];
  bool isLoading = true;
  static const mainColor = Colors.orange;

  @override
  void initState() {
    super.initState();
    cargarProductos();
  }

  void cargarProductos() async {
    try {
      setState(() {
        isLoading = true;
      });

      DatabaseEvent event = await FirebaseDatabase.instance
          .ref()
          .child('productos')
          .once();
      
      DataSnapshot snapshot = event.snapshot;
      
      if (snapshot.value != null) {
        Map<String, dynamic> productosMap = Map<String, dynamic>.from(snapshot.value as Map);
        
        setState(() {
          productos = productosMap.entries.map((entry) {
            Map<String, dynamic> productoData = Map<String, dynamic>.from(entry.value as Map);
            // Asumiendo que quieres usar la key como código
            productoData['codigo'] = int.tryParse(entry.key);
            return Producto.fromJson(productoData);
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          productos = [];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cargarProductos,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CrearProductoScreen()),
              ).then((value) => cargarProductos());
            },
          ),
        ],
      ),
      body: isLoading 
        ? const Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          )
        : productos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay productos disponibles',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              color: Colors.orange.shade50,
              child: GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65, // Cambiado de 0.75 a 0.65 para hacer las tarjetas más altas
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
                itemCount: productos.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    producto: productos[index],
                    mainColor: mainColor,
                  );
                },
              ),
            ),
    );
  }
}

// El ProductCard permanece igual que antes
class ProductCard extends StatelessWidget {
  final Producto producto;
  final Color mainColor;

  const ProductCard({
    Key? key,
    required this.producto,
    required this.mainColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(
          color: mainColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto
          Container(
            height: 140, // Imagen más grande
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.network(
                producto.imagen,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: mainColor.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),
          ),
          // Contenido del producto
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: mainColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  Text(
                    producto.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Descripción del producto
                  Expanded(
                    child: Text(
                      producto.descripcion,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Precio del producto
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '\$${producto.precio.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
