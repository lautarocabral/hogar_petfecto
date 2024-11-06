// ignore_for_file: avoid_print

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

const BASE_URL = 'http://10.0.2.2:5023/api/';

class ApiClient {
  final Dio _dio;
  String? _token;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: BASE_URL,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
              headers: {
                'Content-Type': 'application/json',
              },
            )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log del request
        print('*** Request ***');
        print('URL: ${options.uri}');
        print('Method: ${options.method}');
        print('Headers: ${options.headers}');
        if (options.data != null) {
          print('Body: ${options.data}');
        }

        // Añade el token a cada solicitud si está presente
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
          print('Authorization: Bearer $_token');
        }

        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Log de la respuesta
        print('*** Response ***');
        print('URL: ${response.requestOptions.uri}');
        print('Status Code: ${response.statusCode}');
        print('Data: ${response.data}');
        return handler.next(response);
      },
      onError: (error, handler) {
        // Log del error
        print('*** Error ***');
        print('URL: ${error.requestOptions.uri}');
        print('Error: ${error.message}');
        if (error.response != null) {
          print('Status Code: ${error.response?.statusCode}');
          print('Data: ${error.response?.data}');
        }
        return handler.next(error);
      },
    ));

    // Ignorar certificados en desarrollo (para https local)
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  // Método para configurar el token
  void setToken(String token) {
    _token = token;
    print('Token set: $_token');
  }

  Future<Response> getData(String endpoint) async {
    print('Calling GET $endpoint');
    try {
      final response = await _dio.get(endpoint);
      print('GET $endpoint successful');
      return response;
    } on DioException catch (e) {
      String errorMessage = 'Error en la solicitud GET';
      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
        print('GET $endpoint failed with status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('GET $endpoint failed: ${e.message}');
      }
      throw DioException(
        requestOptions: e.requestOptions,
        error: errorMessage,
      );
    }
  }

  Future<Response> postData(String endpoint, Map<String, dynamic> data) async {
    print('Calling POST $endpoint');
    print('Data: $data');
    try {
      final response = await _dio.post(endpoint, data: data);
      print('POST $endpoint successful');
      return response;
    } on DioException catch (e) {
      // Mensaje de error personalizado
      String errorMessage = 'Error en la solicitud POST';

      if (e.response != null && e.response?.data != null) {
        // Intenta extraer el mensaje de error de la respuesta
        errorMessage = e.response?.data['message'] ?? errorMessage;
        print('POST $endpoint failed with status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('POST $endpoint failed: ${e.message}');
      }

      // Lanza el DioException con el mensaje de error personalizado
      throw DioException(
        requestOptions: e.requestOptions,
        error: errorMessage,
        response: e.response, // Incluye la respuesta para mantener contexto
      );
    }
  }
}
