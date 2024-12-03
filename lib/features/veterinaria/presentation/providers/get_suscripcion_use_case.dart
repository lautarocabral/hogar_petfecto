import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/veterinaria/presentation/models/suscripcion_response_model.dart';

final getSuscripcionUseCaseProvider =
    FutureProvider.autoDispose<SuscripcionResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);

  try {
    final response = await apiClient.getData('Veterinarias/GetMisSuscripciones');

    final apiResponse = ApiResponse<SuscripcionResponseModel>.fromJson(
      response.data,
      (result) => SuscripcionResponseModel.fromJson(result),
    );

    if (apiResponse.statusCode != 200) {
      throw Exception(apiResponse.message ?? 'Error desconocido en el servidor');
    }

    final token = apiResponse.result?.token;
    if (token != null && token.isNotEmpty) {
      apiClient.setToken(token);
    } else {
      throw Exception('El token obtenido es inválido o está vacío');
    }

    return apiResponse.result!;
  } catch (e) {
    throw Exception('Error al obtener las suscripciones: ${e.toString()}');
  }
});

