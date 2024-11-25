import 'package:who/models/modelCotizacionItem.dart';

class Cotizacion {
  String? idCotizacion;
  int idEstadoCoti;
  String codigo;
  String nombreCliente;
  DateTime fecha;
  double iva;
  double subtotal;  // Nuevo campo
  double total;
  List<CotizacionItem> items; // Nuevo campo

  Cotizacion({
    this.idCotizacion,
    required this.idEstadoCoti,
    required this.codigo,
    required this.nombreCliente,
    required this.fecha,
    required this.iva,
    this.subtotal = 0.0,
    required this.total,
    this.items = const [],
  });

  void recalcularTotales() {
    subtotal = items.fold(0, (sum, item) => sum + item.subtotal);
    total = subtotal + (subtotal * (iva / 100));
  }

  // Actualizar toJson y fromJson para incluir los nuevos campos
  Map<String, dynamic> toJson() {
    return {
      'idCotizacion': idCotizacion,
      'idEstadoCoti': idEstadoCoti,
      'codigo': codigo,
      'nombreCliente': nombreCliente,
      'fecha': fecha.toIso8601String(),
      'iva': iva,
      'subtotal': subtotal,
      'total': total,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  static Cotizacion fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      idCotizacion: json['idCotizacion'],
      idEstadoCoti: json['idEstadoCoti'],
      codigo: json['codigo'],
      nombreCliente: json['nombreCliente'] ?? '',
      fecha: json['fecha'] != null
          ? DateTime.parse(json['fecha'])
          : DateTime.now(),
      iva: (json['iva'] as num?)?.toDouble() ?? 0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CotizacionItem.fromJson(item))
          .toList() ?? [],
    );
  }
}