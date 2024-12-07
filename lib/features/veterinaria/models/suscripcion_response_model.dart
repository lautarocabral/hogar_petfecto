class SuscripcionResponseModel {
  String? token;
  SuscripcionModel? suscripcion;

  SuscripcionResponseModel({this.token, this.suscripcion});

  SuscripcionResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    suscripcion = json['suscripcion'] != null
        ? SuscripcionModel.fromJson(json['suscripcion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (suscripcion != null) {
      data['suscripcion'] = suscripcion!.toJson();
    }
    return data;
  }
}

class SuscripcionModel {
  int? id;
  String? fechaInicio;
  String? fechaFin;
  double? monto; 
  bool? estado;
  TipoPlan? tipoPlan;

  SuscripcionModel({
    this.id,
    this.fechaInicio,
    this.fechaFin,
    this.monto,
    this.estado,
    this.tipoPlan,
  });

  SuscripcionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fechaInicio = json['fechaInicio'];
    fechaFin = json['fechaFin'];
    monto = (json['monto'] as num?)?.toDouble(); 
    estado = json['estado'];
    tipoPlan = json['tipoPlan'] != null ? TipoPlanExtension.fromValue(json['tipoPlan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fechaInicio'] = fechaInicio;
    data['fechaFin'] = fechaFin;
    data['monto'] = monto;
    data['estado'] = estado;
    if (tipoPlan != null) {
      data['tipoPlan'] = tipoPlan!.value;
    }
    return data;
  }
}

enum TipoPlan { anual, mensual }

extension TipoPlanExtension on TipoPlan {
  int get value {
    switch (this) {
      case TipoPlan.anual:
        return 0;
      case TipoPlan.mensual:
        return 1;
    }
  }

  static TipoPlan? fromValue(int? value) {
    if (value == null) return null;
    switch (value) {
      case 0:
        return TipoPlan.anual;
      case 1:
        return TipoPlan.mensual;
      default:
        throw ArgumentError('Invalid TipoPlan value: $value');
    }
  }
}
