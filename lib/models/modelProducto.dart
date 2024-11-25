class Producto {
  int? codigo;
  String nombre;
  double precio;
  String descripcion;
  String imagen;

  Producto({this.codigo, required this.nombre, required this.precio, required this.descripcion, required this.imagen});

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'precio': precio,
      'descripcion': descripcion,
      'imagen': imagen,
    };
  }

  static Producto fromJson(Map<String, dynamic> json) {
    return Producto(
      codigo: json['codigo'],
      nombre: json['nombre'],
      precio: (json['precio'] as num).toDouble(),
      descripcion: json['descripcion'],
      imagen: json['imagen'],
    );
  }
}
