class ListaUsuariosResponseModel {
  String? token;
  List<UsuarioDtos>? usuarioDtos;

  ListaUsuariosResponseModel({this.token, this.usuarioDtos});

  ListaUsuariosResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['usuarioDtos'] != null) {
      usuarioDtos = <UsuarioDtos>[];
      json['usuarioDtos'].forEach((v) {
        usuarioDtos!.add(UsuarioDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (usuarioDtos != null) {
      data['usuarioDtos'] = usuarioDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UsuarioDtos {
  String? email;
  String? personaDni;
  Persona? persona;
  List<Grupos>? grupos;

  UsuarioDtos({this.email, this.personaDni, this.persona, this.grupos});

  UsuarioDtos.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    personaDni = json['personaDni'];
    persona =
        json['persona'] != null ? Persona.fromJson(json['persona']) : null;
    if (json['grupos'] != null) {
      grupos = <Grupos>[];
      json['grupos'].forEach((v) {
        grupos!.add(Grupos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['personaDni'] = personaDni;
    if (persona != null) {
      data['persona'] = persona!.toJson();
    }
    if (grupos != null) {
      data['grupos'] = grupos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Persona {
  String? razonSocial;
  String? direccion;
  String? telefono;
  String? fechaNacimiento;
  Localidad? localidad;
  List<Perfiles>? perfiles;
  String? dni;

  Persona(
      {this.razonSocial,
      this.direccion,
      this.telefono,
      this.fechaNacimiento,
      this.localidad,
      this.perfiles,
      this.dni});

  Persona.fromJson(Map<String, dynamic> json) {
    razonSocial = json['razonSocial'];
    direccion = json['direccion'];
    telefono = json['telefono'];
    fechaNacimiento = json['fechaNacimiento'];
    localidad = json['localidad'] != null
        ? Localidad.fromJson(json['localidad'])
        : null;
    if (json['perfiles'] != null) {
      perfiles = <Perfiles>[];
      json['perfiles'].forEach((v) {
        perfiles!.add(Perfiles.fromJson(v));
      });
    }
    dni = json['dni'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['razonSocial'] = razonSocial;
    data['direccion'] = direccion;
    data['telefono'] = telefono;
    data['fechaNacimiento'] = fechaNacimiento;
    if (localidad != null) {
      data['localidad'] = localidad!.toJson();
    }
    if (perfiles != null) {
      data['perfiles'] = perfiles!.map((v) => v.toJson()).toList();
    }
    data['dni'] = dni;
    return data;
  }
}

class Localidad {
  int? id;
  String? localidadNombre;
  Provincia? provincia;

  Localidad({this.id, this.localidadNombre, this.provincia});

  Localidad.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    localidadNombre = json['localidadNombre'];
    provincia = json['provincia'] != null
        ? Provincia.fromJson(json['provincia'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['localidadNombre'] = localidadNombre;
    if (provincia != null) {
      data['provincia'] = provincia!.toJson();
    }
    return data;
  }
}

class Provincia {
  int? id;
  String? provinciaNombre;

  Provincia({this.id, this.provinciaNombre});

  Provincia.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provinciaNombre = json['provinciaNombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['provinciaNombre'] = provinciaNombre;
    return data;
  }
}

class Perfiles {
  int? id;
  TipoPerfil? tipoPerfil;

  Perfiles({this.id, this.tipoPerfil});

  Perfiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipoPerfil = json['tipoPerfil'] != null
        ? TipoPerfil.fromJson(json['tipoPerfil'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (tipoPerfil != null) {
      data['tipoPerfil'] = tipoPerfil!.toJson();
    }
    return data;
  }
}

class TipoPerfil {
  int? id;
  String? descripcion;

  TipoPerfil({this.id, this.descripcion});

  TipoPerfil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descripcion'] = descripcion;
    return data;
  }
}

class Grupos {
  int? id;
  String? descripcion;
  List<Permisos>? permisos;

  Grupos({this.id, this.descripcion, this.permisos});

  Grupos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
    if (json['permisos'] != null) {
      permisos = <Permisos>[];
      json['permisos'].forEach((v) {
        permisos!.add(Permisos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descripcion'] = descripcion;
    if (permisos != null) {
      data['permisos'] = permisos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permisos {
  int? id;
  String? nombrePermiso;

  Permisos({this.id, this.nombrePermiso});

  Permisos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombrePermiso = json['nombrePermiso'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombrePermiso'] = nombrePermiso;
    return data;
  }
}
