import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';

class MascotasStateNotifier extends StateNotifier<UsuarioResponseDto> {
  MascotasStateNotifier() : super(UsuarioResponseDto.empty());

  void setUser(UsuarioResponseDto mascotas) {
    print('Setting mascotas: ${mascotas.email}');
    resetUser();
    state = mascotas;
  }

  void resetUser() {
    print('Resetting mascotas state to empty');
    state = UsuarioResponseDto.empty();
  }
}

final mascotasStateNotifierProvider =
    StateNotifierProvider<MascotasStateNotifier, UsuarioResponseDto?>(
        (ref) => MascotasStateNotifier());
