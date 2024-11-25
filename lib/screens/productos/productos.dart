import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:who/models/modelProducto.dart';



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
      print('Error al cargar productos: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: cargarProductos,
          ),
        ],
      ),
      body: isLoading 
        ? Center(
            child: CircularProgressIndicator(
              color: mainColor,
            ),
          )
        : productos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
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
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
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
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Container(
                width: double.infinity,
                child: Image.network(
                  producto.imagen,
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
          ),
          Expanded(
            flex: 2,
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
                  Text(
                    'Código: ${producto.codigo ?? "N/A"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.nombre,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
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