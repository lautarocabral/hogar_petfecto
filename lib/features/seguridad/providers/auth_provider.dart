import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import '../providers/user_provider.dart';

final loginProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);

  try {
    final response = await apiClient.postData('auth/login', credentials);

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (result) => UserResponse.fromJson(result),
    );

    // Set token and user in the state
    apiClient.setToken(apiResponse.result.token);
    ref
        .read(userStateNotifierProvider.notifier)
        .setUser(apiResponse.result.usuario);
  } on DioException catch (e) {
    // Rethrow to be handled by the UI layer
    throw e;
  }
});

final signUpProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);

  try {
    final response = await apiClient.postData('auth/signup', credentials);

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (result) => result as String, // Ensure parsing as a string
    );

    if (apiResponse.statusCode != 200) {
      throw DioException(
        requestOptions: response.requestOptions,
        error: apiResponse.message,
      );
    }
  } on DioException catch (e) {
    // Rethrow to be handled by UI layer
    throw e;
  }
});
