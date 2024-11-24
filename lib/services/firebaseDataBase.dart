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
  Future<void> createOrUpdateCotizacion(Cotizacion cotizacion) async { 
    await databaseRef.child('cotizaciones/${cotizacion.idCotizacion}').set(cotizacion.toJson()); 
  } 
  
  Future<Cotizacion> readCotizacion(int idCotizacion) async { 
    DatabaseEvent event = await databaseRef.child('cotizaciones/$idCotizacion').once(); 
    DataSnapshot snapshot = event.snapshot; 
    return Cotizacion.fromJson(Map<String, dynamic>.from(snapshot.value as Map)); 
  } 
  
  Future<void> deleteCotizacion(int idCotizacion) async { 
    await databaseRef.child('cotizaciones/$idCotizacion').remove(); 
  }
}
