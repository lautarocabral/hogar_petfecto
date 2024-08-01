import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hogar_petfecto/core/network/dio_client.dart';
import 'package:hogar_petfecto/features/seguridad/data/repository/seguridad_repository.dart';

final dioProvider = Provider<DioClient>((ref) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
  return DioClient(dio);
});

final seguridadRepositoryProvider = Provider<SeguridadRepositoryModel>((ref) {
  final client = ref.watch(dioProvider);
  return SeguridadRepositoryModel(client, '/seguridad');
});
