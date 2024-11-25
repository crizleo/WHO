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
    return {
      'id': id,
      'producto': producto.toJson(),
      'cantidad': cantidad,
      'subtotal': subtotal,
    };
  }

  static CotizacionItem fromJson(Map<String, dynamic> json) {
    return CotizacionItem(
      id: json['id'],
      producto: Producto.fromJson(json['producto']),
      cantidad: json['cantidad'],
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}