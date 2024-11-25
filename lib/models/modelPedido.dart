class Pedido {
  int? codigoPedido;
  int idEstado;
  String codigo;
  double iva;
  double total;
  String cliente;

  Pedido({this.codigoPedido, required this.idEstado, required this.codigo, required this.iva, required this.total, required this.cliente});

  Map<String, dynamic> toJson() {
    return {
      'codigoPedido': codigoPedido,
      'Estado': idEstado,
      'codigo': codigo,
      'iva': iva,
      'total': total,
      'cliente': cliente,
    };
  }

  static Pedido fromJson(Map<String, dynamic> json) {
    return Pedido(
      codigoPedido: json['codigoPedido'],
      idEstado: json['idEstado'],
      codigo: json['codigo'],
      iva: (json['iva'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      cliente: json['cliente'],
    );
  }
}
