class PostulacionesWithPostulantesResponseModel {
  String? token;
  List<MascotaConPersonasDtos>? mascotaConPersonasDtos;

  PostulacionesWithPostulantesResponseModel(
      {this.token, this.mascotaConPersonasDtos});

  PostulacionesWithPostulantesResponseModel.fromJson(
      Map<String, dynamic> json) {
    token = json['token'];
    if (json['mascotaConPersonasDtos'] != null) {
      mascotaConPersonasDtos = <MascotaConPersonasDtos>[];
      json['mascotaConPersonasDtos'].forEach((v) {
        mascotaConPersonasDtos!.add(MascotaConPersonasDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (mascotaConPersonasDtos != null) {
      data['mascotaConPersonasDtos'] =
          mascotaConPersonasDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MascotaConPersonasDtos {
  int? mascotaId;
  String? nombre;
  String? tipoMascota;
  List<Personas>? personas;

  MascotaConPersonasDtos({this.nombre, this.tipoMascota, this.personas});

  MascotaConPersonasDtos.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    mascotaId = json['mascotaId'];
    tipoMascota = json['tipoMascota'];
    if (json['personas'] != null) {
      personas = <Personas>[];
      json['personas'].forEach((v) {
        personas!.add(Personas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['mascotaId'] = mascotaId;
    data['tipoMascota'] = tipoMascota;
    if (personas != null) {
      data['personas'] = personas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Personas {
  String? dni;
  String? razonSocial;
  String? direccion;
  String? telefono;
  String? fechaNacimiento;
  String? estadoCivil;
  String? ocupacion;
  bool? experienciaMascotas;
  int? nroMascotas;
  int? adoptanteId;

  Personas(
      {this.dni,
      this.razonSocial,
      this.direccion,
      this.telefono,
      this.fechaNacimiento,
      this.estadoCivil,
      this.ocupacion,
      this.experienciaMascotas,
      this.nroMascotas,
      this.adoptanteId});

  Personas.fromJson(Map<String, dynamic> json) {
    dni = json['dni'];
    razonSocial = json['razonSocial'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    fechaNacimiento = json['fechaNacimiento'];
    estadoCivil = json['estadoCivil'];
    ocupacion = json['ocupacion'];
    experienciaMascotas = json['experienciaMascotas'];
    nroMascotas = json['nroMascotas'];
    adoptanteId = json['adoptanteId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dni'] = dni;
    data['razonSocial'] = razonSocial;
    data['direccion'] = direccion;
    data['telefono'] = telefono;
    data['fechaNacimiento'] = fechaNacimiento;
    data['estadoCivil'] = estadoCivil;
    data['ocupacion'] = ocupacion;
    data['experienciaMascotas'] = experienciaMascotas;
    data['nroMascotas'] = nroMascotas;
    data['adoptanteId'] = adoptanteId;
    return data;
  }
}
