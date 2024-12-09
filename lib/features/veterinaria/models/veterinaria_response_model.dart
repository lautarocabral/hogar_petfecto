class VeterinariaResponseModel {
  String? token;
  List<Veterinarias>? veterinarias;

  VeterinariaResponseModel({this.token, this.veterinarias});

  VeterinariaResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['veterinarias'] != null) {
      veterinarias = <Veterinarias>[];
      json['veterinarias'].forEach((v) {
        veterinarias!.add(new Veterinarias.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.veterinarias != null) {
      data['veterinarias'] = this.veterinarias!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Veterinarias {
  double? latitud;
  double? longitud;
  List<Suscripciones>? suscripciones;
  String? direccionLocal;
  String? nombre;
  String? telefono;
  List<Ofertas>? ofertas;
  List<Servicios>? servicios;

  Veterinarias(
      {this.latitud,
      this.longitud,
      this.suscripciones,
      this.direccionLocal,
      this.nombre,
      this.telefono,
      this.ofertas,
      this.servicios});

  Veterinarias.fromJson(Map<String, dynamic> json) {
    latitud = json['latitud'];
    longitud = json['longitud'];
    if (json['suscripciones'] != null) {
      suscripciones = <Suscripciones>[];
      json['suscripciones'].forEach((v) {
        suscripciones!.add(new Suscripciones.fromJson(v));
      });
    }
    direccionLocal = json['direccionLocal'];
    nombre = json['nombre'];
    telefono = json['telefono'];
    if (json['ofertas'] != null) {
      ofertas = <Ofertas>[];
      json['ofertas'].forEach((v) {
        ofertas!.add(new Ofertas.fromJson(v));
      });
    }
    if (json['servicios'] != null) {
      servicios = <Servicios>[];
      json['servicios'].forEach((v) {
        servicios!.add(new Servicios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitud'] = this.latitud;
    data['longitud'] = this.longitud;
    if (this.suscripciones != null) {
      data['suscripciones'] =
          this.suscripciones!.map((v) => v.toJson()).toList();
    }
    data['direccionLocal'] = this.direccionLocal;
    data['nombre'] = this.nombre;
    data['telefono'] = this.telefono;
    if (this.ofertas != null) {
      data['ofertas'] = this.ofertas!.map((v) => v.toJson()).toList();
    }
    if (this.servicios != null) {
      data['servicios'] = this.servicios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suscripciones {
  int? id;
  String? fechaInicio;
  String? fechaFin;
  int? monto;
  bool? estado;
  int? tipoPlan;

  Suscripciones(
      {this.id,
      this.fechaInicio,
      this.fechaFin,
      this.monto,
      this.estado,
      this.tipoPlan});

  Suscripciones.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fechaInicio = json['fechaInicio'];
    fechaFin = json['fechaFin'];
    monto = json['monto'];
    estado = json['estado'];
    tipoPlan = json['tipoPlan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fechaInicio'] = this.fechaInicio;
    data['fechaFin'] = this.fechaFin;
    data['monto'] = this.monto;
    data['estado'] = this.estado;
    data['tipoPlan'] = this.tipoPlan;
    return data;
  }
}

class Ofertas {
  int? id;
  String? producto;
  String? imagen;
  String? titulo;
  String? descripcion;
  int? descuento;
  String? fechaInicio;
  String? fechaFin;
  bool? activo;

  Ofertas(
      {this.id,
      this.producto,
      this.imagen,
      this.titulo,
      this.descripcion,
      this.descuento,
      this.fechaInicio,
      this.fechaFin,
      this.activo});

  Ofertas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    producto = json['producto'];
    imagen = json['imagen'];
    titulo = json['titulo'];
    descripcion = json['descripcion'];
    descuento = json['descuento'];
    fechaInicio = json['fechaInicio'];
    fechaFin = json['fechaFin'];
    activo = json['activo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['producto'] = this.producto;
    data['imagen'] = this.imagen;
    data['titulo'] = this.titulo;
    data['descripcion'] = this.descripcion;
    data['descuento'] = this.descuento;
    data['fechaInicio'] = this.fechaInicio;
    data['fechaFin'] = this.fechaFin;
    data['activo'] = this.activo;
    return data;
  }
}

class Servicios {
  int? id;
  String? servicioNombre;
  String? servicioDescripcion;
  int? veterinariaId;

  Servicios(
      {this.id,
      this.servicioNombre,
      this.servicioDescripcion,
      this.veterinariaId});

  Servicios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    servicioNombre = json['servicioNombre'];
    servicioDescripcion = json['servicioDescripcion'];
    veterinariaId = json['veterinariaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['servicioNombre'] = this.servicioNombre;
    data['servicioDescripcion'] = this.servicioDescripcion;
    data['veterinariaId'] = this.veterinariaId;
    return data;
  }
}
