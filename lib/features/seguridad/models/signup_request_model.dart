class SignUpRequestModel {
  String? dni;
  String? razonSocial;
  int? localidadId;
  String? direccion;
  String? telefono;
  String? fechaNacimiento;
  String? email;
  String? password;

  SignUpRequestModel(
      {this.dni,
      this.razonSocial,
      this.localidadId,
      this.direccion,
      this.telefono,
      this.fechaNacimiento,
      this.email,
      this.password});

  SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    dni = json['dni'];
    razonSocial = json['razonSocial'];
    localidadId = json['localidadId'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    fechaNacimiento = json['fechaNacimiento'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dni'] = dni;
    data['razonSocial'] = razonSocial;
    data['localidadId'] = localidadId;
    data['direccion'] = direccion;
    data['telefono'] = telefono;
    data['fechaNacimiento'] = fechaNacimiento;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
