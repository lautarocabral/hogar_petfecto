class ProvinciaResponseModel {
  List<ProvinciaDtos>? provinciaDtos;

  ProvinciaResponseModel({this.provinciaDtos});

  ProvinciaResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['provinciaDtos'] != null) {
      provinciaDtos = <ProvinciaDtos>[];
      json['provinciaDtos'].forEach((v) {
        provinciaDtos!.add(new ProvinciaDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.provinciaDtos != null) {
      data['provinciaDtos'] =
          this.provinciaDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProvinciaDtos {
  int? id;
  String? provinciaNombre;

  ProvinciaDtos({this.id, this.provinciaNombre});

  ProvinciaDtos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provinciaNombre = json['provinciaNombre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provinciaNombre'] = this.provinciaNombre;
    return data;
  }
}
