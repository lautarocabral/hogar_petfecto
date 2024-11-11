import 'package:hogar_petfecto/features/adopcion/models/tipo_mascota_response_model.dart';

class MascotasForProtectorasResponseModel {
  String? token;
  List<MascotasDto>? mascotasDto;

  MascotasForProtectorasResponseModel({this.token, this.mascotasDto});

  MascotasForProtectorasResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    if (json['mascotasDto'] != null) {
      mascotasDto = <MascotasDto>[];
      json['mascotasDto'].forEach((v) {
        mascotasDto!.add(MascotasDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (mascotasDto != null) {
      data['mascotasDto'] = mascotasDto!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MascotasDto {
  int? id;
  String? nombre;
  int? peso;
  bool? aptoDepto;
  bool? aptoPerros;
  String? fechaNacimiento;
  bool? castrado;
  String? sexo;
  bool? vacunado;
  bool? adoptado;
  String? imagen;
  TipoMascota? tipoMascota;

  MascotasDto({
    this.id,
    this.nombre,
    this.peso,
    this.aptoDepto,
    this.aptoPerros,
    this.fechaNacimiento,
    this.castrado,
    this.sexo,
    this.vacunado,
    this.adoptado,
    this.imagen,
    this.tipoMascota,
  });

  MascotasDto.fromJson(Map<String, dynamic> json) {
    tipoMascota = json['tipoMascota'] != null
        ? TipoMascota.fromJson(json['tipoMascota'])
        : null;
    id = json['id'];
    nombre = json['nombre'];
    peso = json['peso'];
    aptoDepto = json['aptoDepto'];
    aptoPerros = json['aptoPerros'];
    fechaNacimiento = json['fechaNacimiento'];
    castrado = json['castrado'];
    sexo = json['sexo'];
    vacunado = json['vacunado'];
    adoptado = json['adoptado'];
    imagen = json['imagen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.tipoMascota != null) {
      data['tipoMascota'] = this.tipoMascota!.toJson();
    }
    data['id'] = id;
    data['tipoMascota'] = tipoMascota;
    data['nombre'] = nombre;
    data['peso'] = peso;
    data['aptoDepto'] = aptoDepto;
    data['aptoPerros'] = aptoPerros;
    data['fechaNacimiento'] = fechaNacimiento;
    data['castrado'] = castrado;
    data['sexo'] = sexo;
    data['vacunado'] = vacunado;
    data['adoptado'] = adoptado;
    data['imagen'] = imagen;
    return data;
  }
}
class TipoMascota {
  int? id;
  String? tipo;

  TipoMascota({this.id, this.tipo});

  TipoMascota.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tipo = json['tipo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['tipo'] = this.tipo;
    return data;
  }
}