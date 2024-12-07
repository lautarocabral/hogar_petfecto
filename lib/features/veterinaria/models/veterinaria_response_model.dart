class VeterinariaResponseModel {
  String? token;
  List<Veterinarias>? veterinarias;

  VeterinariaResponseModel({this.token, this.veterinarias});

  VeterinariaResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['veterinarias'] != null) {
      veterinarias = <Veterinarias>[];
      json['veterinarias'].forEach((v) {
        veterinarias!.add(Veterinarias.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (veterinarias != null) {
      data['veterinarias'] = veterinarias!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Veterinarias {
  double? latitud;
  double? longitud;
  List<Suscripciones>? suscripciones;
  String? direccionLocal;
  List<Ofertas>? ofertas;
  String? nombre;
  String? telefono;

  Veterinarias(
      {this.latitud,
      this.longitud,
      this.suscripciones,
      this.direccionLocal,
      this.ofertas,
      this.nombre,
      this.telefono});

  Veterinarias.fromJson(Map<String, dynamic> json) {
    latitud = json['latitud'];
    longitud = json['longitud'];
    if (json['suscripciones'] != null) {
      suscripciones = <Suscripciones>[];
      json['suscripciones'].forEach((v) {
        suscripciones!.add(Suscripciones.fromJson(v));
      });
    }
    direccionLocal = json['direccionLocal'];
    nombre = json['nombre'];
    telefono = json['telefono'];
    if (json['ofertas'] != null) {
      ofertas = <Ofertas>[];
      json['ofertas'].forEach((v) {
        ofertas!.add(Ofertas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitud'] = latitud;
    data['longitud'] = longitud;
    if (suscripciones != null) {
      data['suscripciones'] = suscripciones!.map((v) => v.toJson()).toList();
    }
    data['direccionLocal'] = direccionLocal;
    if (ofertas != null) {
      data['ofertas'] = ofertas!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fechaInicio'] = fechaInicio;
    data['fechaFin'] = fechaFin;
    data['monto'] = monto;
    data['estado'] = estado;
    data['tipoPlan'] = tipoPlan;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['producto'] = producto;
    data['imagen'] = imagen;
    data['titulo'] = titulo;
    data['descripcion'] = descripcion;
    data['descuento'] = descuento;
    data['fechaInicio'] = fechaInicio;
    data['fechaFin'] = fechaFin;
    data['activo'] = activo;
    return data;
  }
}
