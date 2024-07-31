import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/features/seguridad/data/repository/seguridad_repository.dart';

import '../../../core/providers/dio_provider.dart';

final seguridadRepositoryProvider = Provider<SeguridadRepositoryModel>((ref) {
  final client = ref.watch(dioProvider);
  return SeguridadRepositoryModel(client, '/myModels');
});
