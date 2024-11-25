import 'package:firebase_database/firebase_database.dart';
import '../models/modelProducto.dart';
import '../models/modelPedido.dart';
import '../models/modelUsuarios.dart';
import '../models/modelCotizacion.dart';

class FirebaseService {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  //Productos
  Future<void> createOrUpdateProducto(Producto producto) async {
    await databaseRef.child('productos/${producto.codigo}').set(producto.toJson());
  }

  Future<List<Producto>> getProductos() async {
    try {
      DatabaseEvent event = await databaseRef.child('productos').once();
      DataSnapshot snapshot = event.snapshot;
      
      if (snapshot.value == null) {
        return [];
      }

      // Convertir el snapshot a Map
      Map<dynamic, dynamic> productosMap = snapshot.value as Map<dynamic, dynamic>;
      
      // Convertir cada entrada del Map a un objeto Producto
      List<Producto> productos = productosMap.entries.map((entry) {
        return Producto.fromJson(Map<String, dynamic>.from(entry.value as Map));
      }).toList();

      return productos;
    } catch (e) {
      print('Error al obtener productos: $e');
      throw Exception('Error al obtener la lista de productos: $e');
    }
  }

  Future<Producto> readProducto(int codigo) async {
    DatabaseEvent event = await databaseRef.child('productos/$codigo').once();
    DataSnapshot snapshot = event.snapshot;
    return Producto.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

  Future<void> deleteProducto(int codigo) async {
    await databaseRef.child('productos/$codigo').remove();
  }

  //Pedidos
  Future<void> createOrUpdatePedido(Pedido pedido) async {
    await databaseRef.child('pedidos/${pedido.codigoPedido}').set(pedido.toJson());
  }

  Future<Pedido> readPedido(int codigoPedido) async {
    DatabaseEvent event = await databaseRef.child('pedidos/$codigoPedido').once();
    DataSnapshot snapshot = event.snapshot;
    return Pedido.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

  Future<void> deletePedido(int codigoPedido) async {
    await databaseRef.child('pedidos/$codigoPedido').remove();
  }

  // Usuarios 
  Future<void> createOrUpdateUsuario(Usuario usuario) async { 
    await databaseRef.child('usuarios/${usuario.idUsuario}').set(usuario.toJson()); 
  } 
  
  Future<Usuario> readUsuario(int idUsuario) async { 
    DatabaseEvent event = await databaseRef.child('usuarios/$idUsuario').once(); 
    DataSnapshot snapshot = event.snapshot; 
    return Usuario.fromJson(Map<String, dynamic>.from(snapshot.value as Map)); 
  } 
  
  Future<void> deleteUsuario(int idUsuario) async { 
    await databaseRef.child('usuarios/$idUsuario').remove(); 
  } 
  
  // Cotizaciones 
  Future<String> createOrUpdateCotizacion(Cotizacion cotizacion) async {

  if (cotizacion.idCotizacion == null) {
 
    final newCotizacionRef = databaseRef.child('cotizaciones').push();
    
 
    String newId = newCotizacionRef.key!;
    
    cotizacion.idCotizacion = newId;
    
    await newCotizacionRef.set(cotizacion.toJson());
    return newId;
  } else {

    await databaseRef
        .child('cotizaciones/${cotizacion.idCotizacion}')
        .set(cotizacion.toJson());
    return cotizacion.idCotizacion.toString();
  }
}
  
  Future<Cotizacion> readCotizacion(String idCotizacion) async {
    try {
      
      DatabaseEvent event = await databaseRef.child('cotizaciones/$idCotizacion').once();
      DataSnapshot snapshot = event.snapshot;
      
      if (snapshot.value == null) {
        throw Exception('No se encontró la cotización');
      }

      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      data['idCotizacion'] = idCotizacion;
      
      Cotizacion cotizacion = Cotizacion.fromJson(data);
      
      return cotizacion;
    } catch (e, stackTrace) {
      rethrow;
    }
  }
  
  Future<void> deleteCotizacion(String idCotizacion) async { 
    await databaseRef.child('cotizaciones/$idCotizacion').remove(); 
  }
}
