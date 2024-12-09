class ReportsResponseModel {
  String? token;
  List<Reportes>? reportes;

  ReportsResponseModel({this.token, this.reportes});

  ReportsResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['reportes'] != null) {
      reportes = <Reportes>[];
      json['reportes'].forEach((v) {
        reportes!.add(new Reportes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.reportes != null) {
      data['reportes'] = this.reportes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Reportes {
  String? usuarioNombre;
  int? cantidadDePedidos;
  double? total;

  Reportes({this.usuarioNombre, this.cantidadDePedidos});

  Reportes.fromJson(Map<String, dynamic> json) {
    usuarioNombre = json['usuarioNombre'];
    cantidadDePedidos = json['cantidadDePedidos'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usuarioNombre'] = this.usuarioNombre;
    data['cantidadDePedidos'] = this.cantidadDePedidos;
    return data;
  }
}
