import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';
import 'package:hogar_petfecto/features/seguridad/models/events_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/models/reports_response_model.dart';

final auditoriaUseCaseProvider =
    FutureProvider.autoDispose<EventsResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Auth/GetEvents');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => EventsResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});

final reportsUseCaseProvider =
    FutureProvider.autoDispose<ReportsResponseModel>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Auth/GetReport');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => ReportsResponseModel.fromJson(result),
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  apiClient.setToken(apiResponse.result.token!);

  return apiResponse.result;
});

final makeBackUpUseCaseProvider =
    FutureProvider.autoDispose<String>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response = await apiClient.getData('Auth/MakeBackup');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => String,
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
  // apiClient.setToken(apiResponse.result.token!);

  // return apiResponse.result;
  return 'ok';
});