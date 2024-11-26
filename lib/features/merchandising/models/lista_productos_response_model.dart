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

  Productos(
      {this.id,
      this.descripcion,
      this.stock,
      this.precio,
      this.categoria,
      this.imagen});

  Productos.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    descripcion = json['descripcion'];
    stock = json['stock'];
    precio = json['precio'];
    categoria = json['categoria'] != null
        ? Categoria.fromJson(json['categoria'])
        : null;
    imagen = json['Imagen'];
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
