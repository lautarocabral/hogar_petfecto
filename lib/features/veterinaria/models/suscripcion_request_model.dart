class SuscripcionRequestModel {
  int? suscripcionId;
  TipoPlan? tipoPlan;
  bool? estado;

  SuscripcionRequestModel({this.suscripcionId, this.tipoPlan, this.estado});

  Map<String, dynamic> toMap() {
    return {
      'suscripcionid': suscripcionId,
      'tipoplan': tipoPlan?.index,
      'estado': estado,
    };
  }
}

enum TipoPlan { anual, mensual }
