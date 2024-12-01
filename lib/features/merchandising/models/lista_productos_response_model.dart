class ListaProductosResponseModel {
  String? token;
  List<Productos>? productos;

  ListaProductosResponseModel({this.token, this.productos});

  ListaProductosResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['productos'] != null) {
      productos = <Productos>[];
      json['productos'].forEach((v) {
        productos!.add(Productos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (productos != null) {
      data['productos'] = productos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Productos {
  int? id;
  String? descripcion;
  int? stock;
  double? precio;
  Categoria? categoria;
  String? imagen;
  String? titulo;
  Protectora? protectora;
  int? protectoraId;
  String? nombreProtectora;

  Productos({
    this.id,
    this.descripcion,
    this.stock,
    this.precio,
    this.categoria,
    this.imagen,
    this.titulo,
    this.nombreProtectora,
    this.protectora,
    this.protectoraId,
  });

  Productos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
    stock = json['stock'];
    precio = json['precio'];
    categoria = json['categoria'] != null
        ? Categoria.fromJson(json['categoria'])
        : null;
    protectora = json['protectora'] != null
        ? Protectora.fromJson(json['protectora'])
        : null;
    protectoraId = json['protectoraId'];

    imagen = json['imagen'];
    titulo = json['titulo'];
    nombreProtectora = json['nombreProtectora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descripcion'] = descripcion;
    data['stock'] = stock;
    data['precio'] = precio;
    if (categoria != null) {
      data['categoria'] = categoria!.toJson();
    }
    data['imagen'] = imagen;
    data['titulo'] = titulo;
    data['nombreProtectora'] = nombreProtectora;
    return data;
  }
}

class Categoria {
  int? id;
  String? nombre;

  Categoria({this.id, this.nombre});

  Categoria.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nombre'] = nombre;
    return data;
  }
}

class Protectora {
  int? capacidad;
  int? nroVoluntarios;
  int? cantidadInicialMascotas;

  Protectora({
    this.capacidad,
    this.nroVoluntarios,
    this.cantidadInicialMascotas,
  });

  Protectora.fromJson(Map<String, dynamic> json) {
    capacidad = json['capacidad'];
    nroVoluntarios = json['nroVoluntarios'];
    cantidadInicialMascotas = json['cantidadInicialMascotas'];
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['nombre'] = nombre;
  //   return data;
  // }
}
