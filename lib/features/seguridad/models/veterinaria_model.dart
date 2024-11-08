class VeterinariaModel {
  final String nombre;
  final double latitud;
  final double longitud;
  final List<Suscripcion> suscripciones;
  final String direccionLocal;
  final String telefono;

  VeterinariaModel({
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.suscripciones,
    required this.direccionLocal,
    required this.telefono,
  });

  // Método para crear una instancia de VeterinaryLocation a partir de un Map (por ejemplo, de un JSON)
  factory VeterinariaModel.fromMap(Map<String, dynamic> map) {
    return VeterinariaModel(
      nombre: map['nombre'] as String,
      latitud: (map['latitud'] as num).toDouble(),
      longitud: (map['longitud'] as num).toDouble(),
      suscripciones: (map['suscripciones'] as List<dynamic>)
          .map((e) => Suscripcion.fromMap(e as Map<String, dynamic>))
          .toList(),
      direccionLocal: map['direccionLocal'] as String,
      telefono: map['telefono'] as String,
    );
  }

  // Método para convertir una instancia de VeterinaryLocation a un Map (por ejemplo, para enviar como JSON)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'latitud': latitud,
      'longitud': longitud,
      'suscripciones': suscripciones.map((e) => e.toMap()).toList(),
      'direccionLocal': direccionLocal,
      'telefono': telefono,
    };
  }
}

class Suscripcion {
  final int id;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final double monto;
  final bool estado;

  Suscripcion({
    required this.id,
    required this.fechaInicio,
    required this.fechaFin,
    required this.monto,
    required this.estado,
  });

  factory Suscripcion.fromMap(Map<String, dynamic> map) {
    return Suscripcion(
      id: map['id'] as int,
      fechaInicio: DateTime.parse(map['fechaInicio'] as String),
      fechaFin: DateTime.parse(map['fechaFin'] as String),
      monto: (map['monto'] as num).toDouble(),
      estado: map['estado'] as bool,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaFin': fechaFin.toIso8601String(),
      'monto': monto,
      'estado': estado,
    };
  }
}
