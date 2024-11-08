import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/core/routes/app_router.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';

final adoptanteProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.postData('perfiles/adoptante', credentials);

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

final protectoraProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);

  try {
    final response =
        await apiClient.postData('perfiles/protectora', credentials);

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (result) => UserResponse.fromJson(result),
    );

    apiClient.setToken(apiResponse.result.token);
    ref
        .read(userStateNotifierProvider.notifier)
        .setUser(apiResponse.result.usuario);
  } on DioException catch (e) {
    throw e;
  }
});

final clienteProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.postData('perfiles/cliente', credentials);

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

final veterinariaProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response =
      await apiClient.postData('perfiles/veterinaria', credentials);

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
