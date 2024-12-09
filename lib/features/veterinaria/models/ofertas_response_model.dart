class OfertasResponseModel {
  String? token;
  List<Ofertas>? ofertas;

  OfertasResponseModel({this.token, this.ofertas});

  OfertasResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['ofertas'] != null) {
      ofertas = <Ofertas>[];
      json['ofertas'].forEach((v) {
        ofertas!.add(new Ofertas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.ofertas != null) {
      data['ofertas'] = this.ofertas!.map((v) => v.toJson()).toList();
    }
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
