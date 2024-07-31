import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/dio_client.dart';

final dioProvider = Provider<DioClient>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  return DioClient(dio);
});
