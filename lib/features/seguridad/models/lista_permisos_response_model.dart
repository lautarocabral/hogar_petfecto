class ListaPermisosResponseModel {
  String? token;
  List<PermisosDto>? permisosDto;

  ListaPermisosResponseModel({this.token, this.permisosDto});

  ListaPermisosResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['permisosDto'] != null) {
      permisosDto = <PermisosDto>[];
      json['permisosDto'].forEach((v) {
        permisosDto!.add(PermisosDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (permisosDto != null) {
      data['permisosDto'] = permisosDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PermisosDto {
  int? id;
  String? nombrePermiso;

  PermisosDto({this.id, this.nombrePermiso});

  PermisosDto.fromJson(Map<String, dynamic> json) {
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
