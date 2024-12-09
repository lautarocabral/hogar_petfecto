class EventsResponseModel {
  String? token;
  List<Events>? events;

  EventsResponseModel({this.token, this.events});

  EventsResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Events {
  int? id;
  String? usuario;
  String? email;
  String? detalle;
  String? nombreModulo;
  String? fecha;

  Events(
      {this.id,
      this.usuario,
      this.email,
      this.detalle,
      this.nombreModulo,
      this.fecha});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    usuario = json['usuario'];
    email = json['email'];
    detalle = json['detalle'];
    nombreModulo = json['nombreModulo'];
    fecha = json['fecha'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['usuario'] = this.usuario;
    data['email'] = this.email;
    data['detalle'] = this.detalle;
    data['nombreModulo'] = this.nombreModulo;
    data['fecha'] = this.fecha;
    return data;
  }
}
