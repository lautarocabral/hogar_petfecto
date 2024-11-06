import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/dio_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
