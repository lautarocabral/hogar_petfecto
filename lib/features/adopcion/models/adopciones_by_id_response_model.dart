class AdopcionesByIdResponseModel {
  String? token;
  List<Adopciones>? adopciones;

  AdopcionesByIdResponseModel({this.token, this.adopciones});

  AdopcionesByIdResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['adopciones'] != null) {
      adopciones = <Adopciones>[];
      json['adopciones'].forEach((v) {
        adopciones!.add(Adopciones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (adopciones != null) {
      data['adopciones'] = adopciones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Adopciones {
  int? id;
  Mascota? mascota;
  Adoptante? adoptante;
  String? fecha;
  String? contrato;

  Adopciones(
      {this.id, this.mascota, this.adoptante, this.fecha, this.contrato});

  Adopciones.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mascota =
        json['mascota'] != null ? Mascota.fromJson(json['mascota']) : null;
    adoptante = json['adoptante'] != null
        ? Adoptante.fromJson(json['adoptante'])
        : null;
    fecha = json['fecha'];
    contrato = json['contrato'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (mascota != null) {
      data['mascota'] = mascota!.toJson();
    }
    if (adoptante != null) {
      data['adoptante'] = adoptante!.toJson();
    }
    data['fecha'] = fecha;
    data['contrato'] = contrato;
    return data;
  }
}

class Mascota {
  int? id;
  TipoMascota? tipoMascota;
  String? nombre;
  int? peso;
  bool? aptoDepto;
  bool? aptoPerros;
  String? fechaNacimiento;
  bool? castrado;
  String? sexo;
  bool? vacunado;
  bool? adoptado;
  String? imagen;
  String? descripcion;

  Mascota(
      {this.id,
      this.tipoMascota,
      this.nombre,
      this.peso,
      this.aptoDepto,
      this.aptoPerros,
      this.fechaNacimiento,
      this.castrado,
      this.sexo,
      this.vacunado,
      this.adoptado,
      this.imagen,
      this.descripcion});

  Mascota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoMascota = json['tipoMascota'] != null
        ? TipoMascota.fromJson(json['tipoMascota'])
        : null;
    nombre = json['nombre'];
    peso = json['peso'];
    aptoDepto = json['aptoDepto'];
    aptoPerros = json['aptoPerros'];
    fechaNacimiento = json['fechaNacimiento'];
    castrado = json['castrado'];
    sexo = json['sexo'];
    vacunado = json['vacunado'];
    adoptado = json['adoptado'];
    imagen = json['imagen'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (tipoMascota != null) {
      data['tipoMascota'] = tipoMascota!.toJson();
    }
    data['nombre'] = nombre;
    data['peso'] = peso;
    data['aptoDepto'] = aptoDepto;
    data['aptoPerros'] = aptoPerros;
    data['fechaNacimiento'] = fechaNacimiento;
    data['castrado'] = castrado;
    data['sexo'] = sexo;
    data['vacunado'] = vacunado;
    data['adoptado'] = adoptado;
    data['imagen'] = imagen;
    data['descripcion'] = descripcion;
    return data;
  }
}

class TipoMascota {
  int? id;
  String? tipo;

  TipoMascota({this.id, this.tipo});

  TipoMascota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tipo'] = tipo;
    return data;
  }
}

class Adoptante {
  String? estadoCivil;
  String? ocupacion;
  bool? experienciaMascotas;
  int? nroMascotas;

  Adoptante(
      {this.estadoCivil,
      this.ocupacion,
      this.experienciaMascotas,
      this.nroMascotas});

  Adoptante.fromJson(Map<String, dynamic> json) {
    estadoCivil = json['estadoCivil'];
    ocupacion = json['ocupacion'];
    experienciaMascotas = json['experienciaMascotas'];
    nroMascotas = json['nroMascotas'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['estadoCivil'] = estadoCivil;
    data['ocupacion'] = ocupacion;
    data['experienciaMascotas'] = experienciaMascotas;
    data['nroMascotas'] = nroMascotas;
    return data;
  }
}
