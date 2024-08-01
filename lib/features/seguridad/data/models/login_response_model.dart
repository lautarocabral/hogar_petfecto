class LoginResponseModel {
  final String nombre;
  final String apellido;
  final String email;

  LoginResponseModel({
    required this.nombre,
    required this.apellido,
    required this.email,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
    };
  }
}
