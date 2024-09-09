import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/providers/dio_provider.dart';
import 'package:hogar_petfecto/core/state/generic_state.dart';
import 'package:hogar_petfecto/features/seguridad/data/repository/seguridad_repository.dart';
import 'package:hogar_petfecto/features/seguridad/data/services/seguridad_service.dart';


final seguridadRepositoryProvider = Provider<SeguridadRepositoryModel>((ref) {
  final client = ref.watch(dioProvider);
  return SeguridadRepositoryModel(client, '/seguridad');
});

final seguridadNotifierProvider =
    StateNotifierProvider<SeguridadStateNotifier, GenericState<dynamic>>((ref) {
  final repository = ref.watch(seguridadRepositoryProvider);
  return SeguridadStateNotifier(repository);
});
