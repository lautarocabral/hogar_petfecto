import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/merchandising/models/lista_categorias_response_model.dart';

final listaCategoriaUseCaseProvider =
    FutureProvider.autoDispose<ListaCategoriasResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response =
      await apiClient.getData('Merchandising/GetCategorias');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => ListaCategoriasResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});
