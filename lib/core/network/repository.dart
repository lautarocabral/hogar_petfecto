import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/network/dio_client.dart';

abstract class Repository<T> {
  final DioClient _client;
  final String _endpoint;
  final T Function(Map<String, dynamic>) fromJsonT;

  Repository(this._client, this._endpoint, this.fromJsonT);

  Future<ApiResponse<T>> fetchOne(int id) async {
    try {
      final response = await _client.get('$_endpoint/$id');
      return ApiResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse<List<T>>> fetchAll() async {
    try {
      final response = await _client.get(_endpoint);
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
      final response = await _client.post(_endpoint, data: data);
      return ApiResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse<T>> update(int id, Map<String, dynamic> data) async {
    try {
      final response = await _client.put('$_endpoint/$id', data: data);
      return ApiResponse.fromJson(response.data, fromJsonT);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }

  Future<ApiResponse<void>> delete(int id) async {
    try {
      await _client.delete('$_endpoint/$id');
      return ApiResponse(success: true);
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
