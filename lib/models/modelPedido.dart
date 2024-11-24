class Pedido {
  int? codigoPedido;
  int idEstado;
  String codigo;
  double iva;
  double total;
  String direccion;

  Pedido({this.codigoPedido, required this.idEstado, required this.codigo, required this.iva, required this.total, required this.direccion});

  Map<String, dynamic> toJson() {
    return {
      'codigoPedido': codigoPedido,
      'idEstado': idEstado,
      'codigo': codigo,
      'iva': iva,
      'total': total,
      'direccion': direccion,
    };
  }

  static Pedido fromJson(Map<String, dynamic> json) {
    return Pedido(
      codigoPedido: json['codigoPedido'],
      idEstado: json['idEstado'],
      codigo: json['codigo'],
      iva: json['iva'],
      total: json['total'],
      direccion: json['direccion'],
    );
  }
}
