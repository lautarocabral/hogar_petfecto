import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/state/generic_state.dart';
import 'package:hogar_petfecto/features/seguridad/data/repository/seguridad_repository.dart';
import 'package:hogar_petfecto/features/seguridad/providers/seguridad_providers.dart';

class SeguridadNotifier extends StateNotifier<GenericState> {
  final SeguridadRepositoryModel repository;

  SeguridadNotifier(this.repository) : super(InitialState());

  Future<void> fetchAllModels() async {
    state = LoadingState();
    final response = await repository.fetchAll();
    if (response.success) {
      state = SuccessState(response.data!);
    } else {
      state = ErrorState(response.message ?? 'An error occurred');
    }
  }
}

final seguridadNotifierProvider =
    StateNotifierProvider<SeguridadNotifier, GenericState>((ref) {
  final repository = ref.watch(seguridadRepositoryProvider);
  return SeguridadNotifier(repository);
});
