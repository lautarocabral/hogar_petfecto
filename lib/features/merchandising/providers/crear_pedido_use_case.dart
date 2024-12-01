import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/providers/user_provider.dart';

final crearPedidoUseCaseProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, pedido) async {
  final apiClient = ref.read(apiClientProvider);

  final response =
      await apiClient.postData('Pedidos/CargarPedido', pedido);

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
