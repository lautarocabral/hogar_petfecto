import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/state/generic_state.dart';
import 'package:hogar_petfecto/features/seguridad/data/models/seguridad_model.dart';
import 'package:hogar_petfecto/features/seguridad/data/repository/seguridad_repository.dart';

class SeguridadStateNotifier extends StateNotifier<GenericState<dynamic>> {
  final SeguridadRepositoryModel repository;

  SeguridadStateNotifier(this.repository) : super(InitialState());

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
      state = SuccessState<dynamic>(response.data!);
    } else {
      state = ErrorState(response.message ?? 'An error occurred');
    }
  }
}
