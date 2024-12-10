class VentasResponseModel {
  String? token;
  List<Pedidos>? pedidos;

  VentasResponseModel({this.token, this.pedidos});

  VentasResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['pedidos'] != null) {
      pedidos = <Pedidos>[];
      json['pedidos'].forEach((v) {
        pedidos!.add(Pedidos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (pedidos != null) {
      data['pedidos'] = pedidos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pedidos {
  int? id;
  String? fecha;
  List<LineaPedido>? lineaPedido;
  int? nroOrdenCompra;
  String? fechaOrdenCompra;
  String? idPago;
  String? fechaPago;
  double? monto;
  Cliente? cliente;
  Protectora? protectora;

  Pedidos(
      {this.id,
      this.fecha,
      this.lineaPedido,
      this.nroOrdenCompra,
      this.fechaOrdenCompra,
      this.idPago,
      this.fechaPago,
      this.monto,
      this.cliente,
      this.protectora});

  Pedidos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fecha = json['fecha'];
    if (json['lineaPedido'] != null) {
      lineaPedido = <LineaPedido>[];
      json['lineaPedido'].forEach((v) {
        lineaPedido!.add(LineaPedido.fromJson(v));
      });
    }
    nroOrdenCompra = json['nroOrdenCompra'];
    fechaOrdenCompra = json['fechaOrdenCompra'];
    idPago = json['idPago'];
    fechaPago = json['fechaPago'];
    monto = (json['monto'] as num?)?.toDouble(); // Safely convert to double
    cliente =
        json['cliente'] != null ? Cliente.fromJson(json['cliente']) : null;
    protectora = json['protectora'] != null
        ? Protectora.fromJson(json['protectora'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fecha'] = fecha;
    if (lineaPedido != null) {
      data['lineaPedido'] = lineaPedido!.map((v) => v.toJson()).toList();
    }
    data['nroOrdenCompra'] = nroOrdenCompra;
    data['fechaOrdenCompra'] = fechaOrdenCompra;
    data['idPago'] = idPago;
    data['fechaPago'] = fechaPago;
    data['monto'] = monto;
    if (cliente != null) {
      data['cliente'] = cliente!.toJson();
    }
    if (protectora != null) {
      data['protectora'] = protectora!.toJson();
    }
    return data;
  }
}

class LineaPedido {
  int? id;
  double? precio;
  Producto? producto;
  int? cantidad;

  LineaPedido({this.id, this.precio, this.producto, this.cantidad});

  LineaPedido.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    precio = (json['precio'] as num?)?.toDouble(); // Safely convert to double
    producto =
        json['producto'] != null ? Producto.fromJson(json['producto']) : null;
    cantidad = json['cantidad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['precio'] = precio;
    if (producto != null) {
      data['producto'] = producto!.toJson();
    }
    data['cantidad'] = cantidad;
    return data;
  }
}

class Producto {
  int? id;
  String? descripcion;
  String? titulo;
  int? stock;
  double? precio;
  Categoria? categoria;
  String? imagen;
  int? protectoraId;
  String? nombreProtectora;

  Producto(
      {this.id,
      this.descripcion,
      this.titulo,
      this.stock,
      this.precio,
      this.categoria,
      this.imagen,
      this.protectoraId,
      this.nombreProtectora});

  Producto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descripcion = json['descripcion'];
    titulo = json['titulo'];
    stock = json['stock'];
    precio = (json['precio'] as num?)?.toDouble();
    categoria = json['categoria'] != null
        ? Categoria.fromJson(json['categoria'])
        : null;
    imagen = json['imagen'];
    protectoraId = json['protectoraId'];
    nombreProtectora = json['nombreProtectora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descripcion'] = descripcion;
    data['titulo'] = titulo;
    data['stock'] = stock;
    data['precio'] = precio;
    if (categoria != null) {
      data['categoria'] = categoria!.toJson();
    }
    data['imagen'] = imagen;
    data['protectoraId'] = protectoraId;
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

class Cliente {
  String? cuil;
  String? ocupacion;

  Cliente({this.cuil, this.ocupacion});

  Cliente.fromJson(Map<String, dynamic> json) {
    cuil = json['cuil'];
    ocupacion = json['ocupacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cuil'] = cuil;
    data['ocupacion'] = ocupacion;
    return data;
  }
}

class Protectora {
  int? capacidad;
  int? nroVoluntarios;
  int? cantidadInicialMascotas;
  String? nombreProtectora;

  Protectora(
      {this.capacidad,
      this.nroVoluntarios,
      this.cantidadInicialMascotas,
      this.nombreProtectora});

  Protectora.fromJson(Map<String, dynamic> json) {
    capacidad = json['capacidad'];
    nroVoluntarios = json['nroVoluntarios'];
    cantidadInicialMascotas = json['cantidadInicialMascotas'];
    nombreProtectora = json['nombreProtectora'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['capacidad'] = capacidad;
    data['nroVoluntarios'] = nroVoluntarios;
    data['cantidadInicialMascotas'] = cantidadInicialMascotas;
    data['nombreProtectora'] = nombreProtectora;
    return data;
  }
}
