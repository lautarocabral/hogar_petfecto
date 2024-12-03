import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/merchandising/models/oc_response_model.dart';

final ordenCompraUseCaseProvider =
   FutureProvider.autoDispose
    .family<OcResponseModel, int>((ref, nroPedido) async {
  final apiClient = ref.read(apiClientProvider);

  final response =
      await apiClient.getData('Pedidos/ObtenerOrdenCompra/$nroPedido');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => OcResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }

  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});

