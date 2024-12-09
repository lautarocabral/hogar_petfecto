import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';

final qrDecodeUserUseCaseProvider =
    FutureProvider.autoDispose.family<void, String>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);

  try {
    final response =
        await apiClient.getData('Veterinarias/QrDecode/$credentials');

    final apiResponse = ApiResponse.fromJson(
      response.data,
      (result) => String,
    );

    // Set token and user in the state
    // apiClient.setToken(apiResponse.result.token);
    // ref
    //     .read(userStateNotifierProvider.notifier)
    //     .setUser(apiResponse.result.usuario);
    return;
  } on DioException catch (e) {
    throw Exception('Error al procesar la solicitud: $e');
  }
});
