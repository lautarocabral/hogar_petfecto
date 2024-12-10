import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/providers/api_client_provider.dart';

final logoutUseCaseProvider =
    FutureProvider.autoDispose<void>((ref) async {
  final apiClient = ref.read(apiClientProvider);
  final response =
      await apiClient.getData('Auth/Logout');

  final apiResponse = ApiResponse.fromJson(
    response.data,
    (result) => String,
  );

  if (apiResponse.statusCode != 200) {
    throw Exception(apiResponse.message);
  }
});
