// user_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/seguridad/providers/state/user_state.dart';

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(InitialUserState());

  void setUser(String nombre, String apellido, String email) {
    state = AuthenticatedUserState(
        nombre: nombre, apellido: apellido, email: email);
  }

  void clearUser() {
    state = UnauthenticatedUserState();
  }
}

final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});
