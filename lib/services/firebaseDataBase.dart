import 'package:firebase_database/firebase_database.dart';
import '../models/modelProducto.dart';
import '../models/modelPedido.dart';

class FirebaseService {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

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
}
