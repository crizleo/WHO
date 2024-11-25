import 'package:who/models/modelProducto.dart';

class CotizacionItem {
  String? id;
  Producto producto;
  int cantidad;
  double subtotal;

  CotizacionItem({
    this.id,
    required this.producto,
    required this.cantidad,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() {
    var json = {
      'id': id,
      'producto': producto.toJson(),
      'cantidad': cantidad,
      'subtotal': subtotal,
    };
    return json;
  }

  static CotizacionItem fromJson(Map<String, dynamic> json) {
    try {
      if (json['producto'] == null) {
        throw Exception('El campo producto es nulo');
      }

      Map<String, dynamic> productoMap = Map<String, dynamic>.from(json['producto']);
      
      var producto = Producto.fromJson(productoMap);
      var cantidad = json['cantidad'] as int;
      var subtotal = (json['subtotal'] as num).toDouble();

      return CotizacionItem(
        id: json['id'],
        producto: producto,
        cantidad: cantidad,
        subtotal: subtotal,
      );
    } catch (e, stackTrace) {
      rethrow;
    }
  }
}