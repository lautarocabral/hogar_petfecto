import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/features/adopcion/models/adopciones_by_id_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';

import '../../../core/providers/api_client_provider.dart';

final cargarPostulacionUseCaseProvider =
    FutureProvider.autoDispose.family<void, int>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response =
      await apiClient.getData('adopciones/CargaPostulacion/$credentials');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => UserResponse.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }

  apiClient.setToken(apiResponse.result.token);
  ref
      .read(userStateNotifierProvider.notifier)
      .setUser(apiResponse.result.usuario);
});


// Provider para obtener las adopciones
final getMisAdopcionesUseCaseProvider = FutureProvider.autoDispose<AdopcionesByIdResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Adopciones/GetMisAdopciones');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => AdopcionesByIdResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }

  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});