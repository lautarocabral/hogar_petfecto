class GetPostulacionByIdResponseModel {
  String? token;
  List<PostulacionDtos>? postulacionDtos;

  GetPostulacionByIdResponseModel({this.token, this.postulacionDtos});

  GetPostulacionByIdResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['postulacionDtos'] != null) {
      postulacionDtos = <PostulacionDtos>[];
      json['postulacionDtos'].forEach((v) {
        postulacionDtos!.add(new PostulacionDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.postulacionDtos != null) {
      data['postulacionDtos'] =
          this.postulacionDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostulacionDtos {
  int? id;
  Adoptante? adoptante;
  Mascota? mascota;
  String? fecha;
  Estado? estado;

  PostulacionDtos(
      {this.id, this.adoptante, this.mascota, this.fecha, this.estado});

  PostulacionDtos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adoptante = json['adoptante'] != null
        ? new Adoptante.fromJson(json['adoptante'])
        : null;
    mascota =
        json['mascota'] != null ? new Mascota.fromJson(json['mascota']) : null;
    fecha = json['fecha'];
    estado =
        json['estado'] != null ? new Estado.fromJson(json['estado']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.adoptante != null) {
      data['adoptante'] = this.adoptante!.toJson();
    }
    if (this.mascota != null) {
      data['mascota'] = this.mascota!.toJson();
    }
    data['fecha'] = this.fecha;
    if (this.estado != null) {
      data['estado'] = this.estado!.toJson();
    }
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['estadoCivil'] = this.estadoCivil;
    data['ocupacion'] = this.ocupacion;
    data['experienciaMascotas'] = this.experienciaMascotas;
    data['nroMascotas'] = this.nroMascotas;
    return data;
  }
}

class Mascota {
  int? id;
  Null? tipoMascota;
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
    tipoMascota = json['tipoMascota'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipoMascota'] = this.tipoMascota;
    data['nombre'] = this.nombre;
    data['peso'] = this.peso;
    data['aptoDepto'] = this.aptoDepto;
    data['aptoPerros'] = this.aptoPerros;
    data['fechaNacimiento'] = this.fechaNacimiento;
    data['castrado'] = this.castrado;
    data['sexo'] = this.sexo;
    data['vacunado'] = this.vacunado;
    data['adoptado'] = this.adoptado;
    data['imagen'] = this.imagen;
    data['descripcion'] = this.descripcion;
    return data;
  }
}

class Estado {
  int? id;
  String? estado;

  Estado({this.id, this.estado});

  Estado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['estado'] = this.estado;
    return data;
  }
}
