class TipoMascotaResponseModel {
  String? token;
  List<TiposMascotas>? tiposMascotas;

  TipoMascotaResponseModel({this.token, this.tiposMascotas});

  TipoMascotaResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['tiposMascotas'] != null) {
      tiposMascotas = <TiposMascotas>[];
      json['tiposMascotas'].forEach((v) {
        tiposMascotas!.add(new TiposMascotas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.tiposMascotas != null) {
      data['tiposMascotas'] =
          this.tiposMascotas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TiposMascotas {
  int? id;
  String? tipo;

  TiposMascotas({this.id, this.tipo});

  TiposMascotas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipo'] = this.tipo;
    return data;
  }
}
