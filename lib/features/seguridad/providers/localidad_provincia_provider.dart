import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/localidad_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/provincia_response_model.dart';

// Provider para obtener las provincias
final provinciaProvider = FutureProvider<List<ProvinciaDtos>>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('provincias/provincias');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => ProvinciaResponseModel.fromJson(result).provinciaDtos ?? [],
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }

  return apiResponse.result;
});


// Provider para obtener las localidades según la provincia seleccionada
final localidadProvider = FutureProvider.family<List<LocalidadDtos>, int>((ref, provinceId) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('provincias/localidades/$provinceId');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => (result['localidadDtos'] as List)
        .map((item) => LocalidadDtos.fromJson(item))
        .toList(),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }

  return apiResponse.result;
});
