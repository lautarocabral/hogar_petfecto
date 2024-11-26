class ListaCategoriasResponseModel {
  String? token;
  List<Categorias>? categorias;

  ListaCategoriasResponseModel({this.token, this.categorias});

  ListaCategoriasResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['categorias'] != null) {
      categorias = <Categorias>[];
      json['categorias'].forEach((v) {
        categorias!.add(Categorias.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (categorias != null) {
      data['categorias'] = categorias!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categorias {
  int? id;
  String? nombre;

  Categorias({this.id, this.nombre});

  Categorias.fromJson(Map<String, dynamic> json) {
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
