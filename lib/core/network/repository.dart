// repository.dart

import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/network/dio_client.dart';

abstract class Repository<T> {
  final DioClient client;
  final String endpoint;
  final T Function(Map<String, dynamic>) fromJsonT;

  Repository(this.client, this.endpoint, this.fromJsonT);

  Future<ApiResponse<T>> fetchOne(int id) async {
    try {
      final response = await client.get('$endpoint/$id');
      return ApiResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse<List<T>>> fetchAll() async {
    try {
      final response = await client.get(endpoint);
      final data = (response.data['data'] as List)
          .map((item) => fromJsonT(item))
          .toList();
      return ApiResponse(
          success: response.data['success'],
          data: data,
          message: response.data['message']);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse<T>> create(Map<String, dynamic> data) async {
    try {
      final response = await client.post(endpoint, data: data);
      return ApiResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse<T>> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await client.put('$endpoint/$id', data: data);
      return ApiResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse<void>> delete(int id) async {
    try {
      await client.delete('$endpoint/$id');
      return ApiResponse(success: true);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
