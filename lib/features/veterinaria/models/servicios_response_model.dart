class ServiciosResponseModel {
  String? token;
  List<Servicios>? servicios;

  ServiciosResponseModel({this.token, this.servicios});

  ServiciosResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['servicios'] != null) {
      servicios = <Servicios>[];
      json['servicios'].forEach((v) {
        servicios!.add(new Servicios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.servicios != null) {
      data['servicios'] = this.servicios!.map((v) => v.toJson()).toList();
    }
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
