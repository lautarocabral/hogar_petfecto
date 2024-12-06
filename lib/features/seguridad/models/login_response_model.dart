class UserResponse {
  final String token;
  final UsuarioResponseDto usuario;

  UserResponse({required this.token, required this.usuario});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      token: json['token'],
      usuario: UsuarioResponseDto.fromJson(json['usuarioResponseDto']),
    );
  }

  factory UserResponse.empty() {
    return UserResponse(
      token: '',
      usuario: UsuarioResponseDto.empty(),
    );
  }
}

class UsuarioResponseDto {
  final String email;
  final String personaDni;
  final Persona persona;
  final List<Grupo> grupos;
  final List<int> hasToUpdateProfile;

  UsuarioResponseDto({
    required this.email,
    required this.personaDni,
    required this.persona,
    required this.grupos,
    required this.hasToUpdateProfile,
  });

  factory UsuarioResponseDto.fromJson(Map<String, dynamic> json) {
    return UsuarioResponseDto(
      email: json['email'] ?? '',
      personaDni: json['personaDni'] ?? '',
      persona: Persona.fromJson(json['persona']),
      grupos: (json['grupos'] as List).map((i) => Grupo.fromJson(i)).toList(),
      hasToUpdateProfile: (json['hasToUpdateProfile'] as List<dynamic>?)
              ?.map((i) => i as int)
              .toList() ??
          [],
    );
  }

  factory UsuarioResponseDto.empty() {
    return UsuarioResponseDto(
      email: '',
      personaDni: '',
      persona: Persona.empty(),
      grupos: [],
      hasToUpdateProfile: [],
    );
  }
}


class Persona {
  final String razonSocial;
  final String direccion;
  final String telefono;
  final DateTime fechaNacimiento;
  final Localidad localidad;
  final List<Perfil> perfiles;

  Persona({
    required this.razonSocial,
    required this.direccion,
    required this.telefono,
    required this.fechaNacimiento,
    required this.localidad,
    required this.perfiles,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      razonSocial: json['razonSocial'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
      localidad: Localidad.fromJson(json['localidad']),
      perfiles:
          (json['perfiles'] as List).map((i) => Perfil.fromJson(i)).toList(),
    );
  }

  factory Persona.empty() {
    return Persona(
      razonSocial: '',
      direccion: '',
      telefono: '',
      fechaNacimiento: DateTime(1970), // Fecha predeterminada
      localidad: Localidad.empty(),
      perfiles: [],
    );
  }
}

class Localidad {
  final int id;
  final String localidadNombre;
  final Provincia provincia;

  Localidad({
    required this.id,
    required this.localidadNombre,
    required this.provincia,
  });

  factory Localidad.fromJson(Map<String, dynamic> json) {
    return Localidad(
      id: json['id'],
      localidadNombre: json['localidadNombre'],
      provincia: Provincia.fromJson(json['provincia']),
    );
  }

  factory Localidad.empty() {
    return Localidad(
      id: 0,
      localidadNombre: '',
      provincia: Provincia.empty(),
    );
  }
}

class Provincia {
  final int id;
  final String provinciaNombre;

  Provincia({
    required this.id,
    required this.provinciaNombre,
  });

  factory Provincia.fromJson(Map<String, dynamic> json) {
    return Provincia(
      id: json['id'],
      provinciaNombre: json['provinciaNombre'],
    );
  }

  factory Provincia.empty() {
    return Provincia(
      id: 0,
      provinciaNombre: '',
    );
  }
}

class Perfil {
  final int id;
  final TipoPerfil tipoPerfil;

  Perfil({
    required this.id,
    required this.tipoPerfil,
  });

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      id: json['id'],
      tipoPerfil: TipoPerfil.fromJson(json['tipoPerfil']),
    );
  }

  factory Perfil.empty() {
    return Perfil(
      id: 0,
      tipoPerfil: TipoPerfil.empty(),
    );
  }
}

class TipoPerfil {
  final int id;
  final String descripcion;

  TipoPerfil({
    required this.id,
    required this.descripcion,
  });

  factory TipoPerfil.fromJson(Map<String, dynamic> json) {
    return TipoPerfil(
      id: json['id'],
      descripcion: json['descripcion'],
    );
  }

  factory TipoPerfil.empty() {
    return TipoPerfil(
      id: 0,
      descripcion: '',
    );
  }
}

class Grupo {
  final int id;
  final String descripcion;
  final List<Permiso> permisos;

  Grupo({
    required this.id,
    required this.descripcion,
    required this.permisos,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      id: json['id'],
      descripcion: json['descripcion'],
      permisos:
          (json['permisos'] as List).map((i) => Permiso.fromJson(i)).toList(),
    );
  }

  factory Grupo.empty() {
    return Grupo(
      id: 0,
      descripcion: '',
      permisos: [],
    );
  }
}

class Permiso {
  final int id;
  final String nombrePermiso;

  Permiso({
    required this.id,
    required this.nombrePermiso,
  });

  factory Permiso.fromJson(Map<String, dynamic> json) {
    return Permiso(
      id: json['id'],
      nombrePermiso: json['nombrePermiso'],
    );
  }

  factory Permiso.empty() {
    return Permiso(
      id: 0,
      nombrePermiso: '',
    );
  }
}
