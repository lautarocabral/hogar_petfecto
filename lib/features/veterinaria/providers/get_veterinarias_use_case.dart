import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/veterinaria/models/veterinaria_response_model.dart';

final getVeterinariasUseUseCaseProvider =
    FutureProvider.autoDispose<VeterinariaResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Veterinarias/GetVeterinarias');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => VeterinariaResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});
