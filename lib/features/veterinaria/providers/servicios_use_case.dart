import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';
import 'package:hogar_petfecto/features/veterinaria/models/servicios_response_model.dart';

final serviciosUseCaseProvider =
    FutureProvider.autoDispose<ServiciosResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Veterinarias/GetServicios');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => ServiciosResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});


final addServicioUseCaseProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.postData('Veterinarias/AgregarServicios', credentials);

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

final editServicioUseCaseProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.postData('Veterinarias/EditarServicios', credentials);

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

final deleteServicioUseCaseProvider =
    FutureProvider.family<void, int>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Veterinarias/DeleteServicio/$credentials');

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
