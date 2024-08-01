import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/state/generic_state.dart';
import 'package:hogar_petfecto/features/seguridad/data/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/data/models/seguridad_model.dart';
import 'package:hogar_petfecto/features/seguridad/data/repository/seguridad_repository.dart';
import 'package:hogar_petfecto/features/seguridad/providers/seguridad_providers.dart';

import 'user_notifier.dart';

class SeguridadNotifier extends StateNotifier<GenericState<dynamic>> {
  final SeguridadRepositoryModel repository;
  final UserNotifier userNotifier;

  SeguridadNotifier(this.repository, this.userNotifier) : super(InitialState());

  Future<void> fetchAllModels() async {
    state = LoadingState();
    final response = await repository.fetchAll();
    if (response.success) {
      state = SuccessState<List<SeguridadModel>>(response.data!);
    } else {
      state = ErrorState(response.message ?? 'An error occurred');
    }
  }

  Future<void> loginUser(String user, String password) async {
    state = LoadingState();
    final response = await repository.loginUser({
      'user': user,
      'password': password,
    });
    if (response.success) {
      final loginData = response.data!;
      userNotifier.setUser(
          loginData.nombre, loginData.apellido, loginData.email);
      state = SuccessState<LoginResponseModel>(loginData);
    } else {
      state = ErrorState(response.message ?? 'An error occurred');
    }
  }
}

final seguridadNotifierProvider =
    StateNotifierProvider<SeguridadNotifier, GenericState<dynamic>>((ref) {
  final repository = ref.watch(seguridadRepositoryProvider);
  final userNotifier = ref.read(userNotifierProvider.notifier);
  return SeguridadNotifier(repository, userNotifier);
});
