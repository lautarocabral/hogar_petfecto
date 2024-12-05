import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_grupos_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_permisos_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/lista_usuarios_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';

final listaUsuariosUseCaseProvider =
    FutureProvider.autoDispose<ListaUsuariosResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Auth/GetUsuarios');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => ListaUsuariosResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});

final listaGruposUseCaseProvider =
    FutureProvider.autoDispose<ListaGruposResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Auth/GetGrupos');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => ListaGruposResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});

final listaPermisosUseCaseProvider =
    FutureProvider.autoDispose<ListaPermisosResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Auth/GetPermisos');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => ListaPermisosResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});

final editarUsuarioUseCaseProvider =
    FutureProvider.autoDispose.family<void, Map<String, dynamic>>(
  (ref, credentials) async {
    final apiClient = ref.read(apiClientProvider);

    try {
      final response =
          await apiClient.postData('Auth/EditarUsuario', credentials);

      final apiResponse = ApiResponse.fromJson(
        response.data,
        (result) => UserResponse.fromJson(result),
      );

      if (apiResponse.statusCode != 200) {
        throw Exception(apiResponse.message);
      }

      apiClient.setToken(apiResponse.result.token);

      return;
    } catch (error) {
      throw Exception('Error al procesar la solicitud: $error');
    }
  },
);
