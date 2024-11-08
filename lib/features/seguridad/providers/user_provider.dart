import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';

class UserStateNotifier extends StateNotifier<UsuarioResponseDto> {
  UserStateNotifier() : super(UsuarioResponseDto.empty());

  void setUser(UsuarioResponseDto usuario) {
    print('Setting user: ${usuario.email}');
    resetUser();
    state = usuario;
  }

  void resetUser() {
    print('Resetting user state to empty');
    state = UsuarioResponseDto.empty();
  }
}

final userStateNotifierProvider =
    StateNotifierProvider<UserStateNotifier, UsuarioResponseDto?>(
        (ref) => UserStateNotifier());
