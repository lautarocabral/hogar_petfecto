import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import '../providers/user_provider.dart';

final loginProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, credentials) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.postData('auth/login', credentials);

  // Parsear la respuesta usando ApiResponse y UserResponse
  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => UserResponse.fromJson(result),
  );

  // Verifica el estado y lanza una excepción si el statusCode es diferente de 200
  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }

  
  ref.read(userStateNotifierProvider.notifier).setUser(apiResponse.result.usuario);
});
