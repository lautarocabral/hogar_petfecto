class LocalidadResponseModel {
  List<LocalidadDtos>? localidadDtos;

  LocalidadResponseModel({this.localidadDtos});

  LocalidadResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['localidadDtos'] != null) {
      localidadDtos = <LocalidadDtos>[];
      json['localidadDtos'].forEach((v) {
        localidadDtos!.add(new LocalidadDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.localidadDtos != null) {
      data['localidadDtos'] =
          this.localidadDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LocalidadDtos {
  int? id;
  String? localidadNombre;
  Null? provincia;

  LocalidadDtos({this.id, this.localidadNombre, this.provincia});

  LocalidadDtos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    localidadNombre = json['localidadNombre'];
    provincia = json['provincia'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['localidadNombre'] = this.localidadNombre;
    data['provincia'] = this.provincia;
    return data;
  }
}
