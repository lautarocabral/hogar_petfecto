import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/adopcion/models/get_postulacion_by_id_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';

final getPostulacionByIdUseCaseProvider = FutureProvider.autoDispose
    .family<GetPostulacionByIdResponseModel, int>((ref, id) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('adopciones/GetMisPostulaciones/$id');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => GetPostulacionByIdResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }

  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});

final deletePostulacionUseCaseProvider = FutureProvider.autoDispose
    .family((ref, id) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('adopciones/DeletePostulacion/$id');

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
