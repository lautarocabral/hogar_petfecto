import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/adopcion/models/mascotas_for_protectoras_response_model.dart';
import 'package:hogar_petfecto/features/adopcion/models/tipo_mascota_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';

final getMascotasForProtectoraProvider =
    FutureProvider.autoDispose<MascotasForProtectorasResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('mascotas/GetMascotasForProtectora');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => MascotasForProtectorasResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});


final cargarMascotasProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.postData('mascotas/CargaMascota', credentials);

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

// Provider para obtener los tipos de mascotas
final getTipoMascotasProvider =
    FutureProvider<TipoMascotaResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('mascotas/GetTipoMascotas');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => TipoMascotaResponseModel.fromJson(result),
  );
  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});


final deleteMascotaUseCaseProvider =
    FutureProvider.family<void, int>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('mascotas/DeleteMascota/$credentials');
   if (response.statusCode != 200) {
    throw Exception(response.data.toString());
  }

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


final editarMascotaUseCaseProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.postData('mascotas/EditarMascota', credentials);

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