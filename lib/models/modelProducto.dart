/*class usuario{
  String nombre;
  String apellido;
  String correo;
  String telefono;
  String direccion;

  usuario({
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.telefono,
    required this.direccion,
  });

  factory usuario.fromMap(Map<String, dynamic> json) => usuario(
      nombre: json["nombre"],
      apellido: json["apellido"],
      correo: json["correo"],
      telefono: json["telefono"],
      direccion: json["direccion"],
    );
}*/

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
      precio: json['precio'],
      descripcion: json['descripcion'],
      imagen: json['imagen'],
    );
  }
}
