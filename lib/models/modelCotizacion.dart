import 'package:who/models/modelCotizacionItem.dart';

class Cotizacion {
  String? idCotizacion;
  int idEstadoCoti;
  String codigo;
  String nombreCliente;
  DateTime fecha;
  double iva;
  double subtotal;
  double total;
  List<CotizacionItem> items;

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

  Map<String, dynamic> toJson() {
    
    var json = {
      'idCotizacion': idCotizacion,
      'idEstadoCoti': idEstadoCoti,
      'codigo': codigo,
      'nombreCliente': nombreCliente,
      'fecha': fecha.toIso8601String(),
      'iva': iva,
      'subtotal': subtotal,
      'total': total,
      'items': items.asMap().map((key, item) {
        print('📝 Convirtiendo item $key a JSON');
        return MapEntry(key.toString(), item.toJson());
      }),
    };
    
    return json;
  }

  static Cotizacion fromJson(Map<String, dynamic> json) {

    try {
      List<CotizacionItem> parseItems(dynamic itemsData) {
        
        List<CotizacionItem> items = [];
        
        if (itemsData != null && itemsData is Map) {
          itemsData.forEach((key, value) {
            
            if (value is Map) {
              try {
                Map<String, dynamic> itemMap = Map<String, dynamic>.from(value);
                var item = CotizacionItem.fromJson(itemMap);
                items.add(item);
              } catch (e) {
                
              }
            }
          });
        }
        
        print('📋 Total de items parseados: ${items.length}');
        return items;
      }

      var fecha = DateTime.parse(json['fecha'] ?? DateTime.now().toIso8601String());
      var iva = (json['iva'] as num?)?.toDouble() ?? 19.0;
      var subtotal = (json['subtotal'] as num?)?.toDouble() ?? 0.0;
      var total = (json['total'] as num?)?.toDouble() ?? 0.0;
      
      var items = parseItems(json['items']);
      print('📋 Items parseados: ${items.length}');

      return Cotizacion(
        idCotizacion: json['idCotizacion'],
        idEstadoCoti: json['idEstadoCoti'] ?? 1,
        codigo: json['codigo'] ?? '',
        nombreCliente: json['nombreCliente'] ?? '',
        fecha: fecha,
        iva: iva,
        subtotal: subtotal,
        total: total,
        items: items,
      );
    } catch (e, stackTrace) {
      
      rethrow;
    }
  }
}