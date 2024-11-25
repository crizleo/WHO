class Usuario {
  int? idUsuario;
  String email;
  String contrasena;
  String identificacion;
  String primerNombre;
  String segundoNombre;
  String primerApellido;
  String segundoApellido;
  String celular;
  String direccion;

  Usuario({
    this.idUsuario,
    required this.email,
    required this.contrasena,
    required this.identificacion,
    required this.primerNombre,
    this.segundoNombre = '',
    required this.primerApellido,
    this.segundoApellido = '',
    required this.celular,
    required this.direccion,
  });

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'email': email,
      'contrasena': contrasena,
      'identificacion': identificacion,
      'primerNombre': primerNombre,
      'segundoNombre': segundoNombre,
      'primerApellido': primerApellido,
      'segundoApellido': segundoApellido,
      'celular': celular,
      'direccion': direccion,
    };
  }

  static Usuario fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      email: json['email'],
      contrasena: json['contrasena'],
      identificacion: json['identificacion'],
      primerNombre: json['primerNombre'],
      segundoNombre: json['segundoNombre'],
      primerApellido: json['primerApellido'],
      segundoApellido: json['segundoApellido'],
      celular: json['celular'],
      direccion: json['direccion'],
    );
  }
}
