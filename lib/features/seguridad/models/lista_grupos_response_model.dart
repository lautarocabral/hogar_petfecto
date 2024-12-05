class ListaGruposResponseModel {
  String? token;
  List<GruposDto>? gruposDto;

  ListaGruposResponseModel({this.token, this.gruposDto});

  ListaGruposResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['gruposDto'] != null) {
      gruposDto = <GruposDto>[];
      json['gruposDto'].forEach((v) {
        gruposDto!.add(GruposDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (gruposDto != null) {
      data['gruposDto'] = gruposDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GruposDto {
  int? id;
  String? descripcion;
  List<Permisos>? permisos;

  GruposDto({this.id, this.descripcion, this.permisos});

  GruposDto.fromJson(Map<String, dynamic> json) {
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
