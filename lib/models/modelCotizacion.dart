class Cotizacion {
  int? idCotizacion;
  int idEstadoCoti;
  String codigo;
  String nombreCliente;
  String fecha;
  double iva;
  double total;
  String imagen;

  Cotizacion({
    this.idCotizacion,
    required this.idEstadoCoti,
    required this.codigo,
    required this.nombreCliente,
    required this.fecha,
    required this.iva,
    required this.total,
    required this.imagen,
  });

  Map<String, dynamic> toJson() {
    return {
      'idCotizacion': idCotizacion,
      'idEstadoCoti': idEstadoCoti,
      'codigo': codigo,
      'nombreCliente': nombreCliente,
      'fecha': fecha,
      'iva': iva,
      'total': total,
      'imagen': imagen,
    };
  }

  static Cotizacion fromJson(Map<String, dynamic> json) {
    return Cotizacion(
      idCotizacion: json['idCotizacion'],
      idEstadoCoti: json['idEstadoCoti'],
      codigo: json['codigo'],
      nombreCliente: json['nombreCliente'] ?? '', // Manejar valores nulos
      fecha: json['fecha'] ?? '', // Manejar valores nulos
      iva: (json['iva'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      imagen: json['imagen'] ?? '', // Manejar valores nulos
    );
  }
}