// lib/utils/validators.dart

class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo electrónico';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Ingresa un correo electrónico válido';
    }
    return null;
  }

  static String? fieldRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    return null;
  }

  static String? dni(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (value.length < 8) {
      return 'El DNI tiene que tener por lo menos 8 caracteres';
    }
    return null;
  }
  
  static String? cuil(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido';
    }
    if (value.length != 11) {
      return 'El CUIL tiene que tener por lo menos 11 caracteres';
    }
    return null;
  }
}
