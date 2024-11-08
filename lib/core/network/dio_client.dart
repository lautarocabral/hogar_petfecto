import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hogar_petfecto/core/routes/app_router.dart';
import 'package:hogar_petfecto/features/home/screens/home_page.dart';
import 'package:hogar_petfecto/features/seguridad/presentation/login_page.dart';

const BASE_URL = 'http://10.0.2.2:5023/api/';

class ApiClient {
  final Dio _dio;
  String? _token;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: BASE_URL,
              connectTimeout: const Duration(seconds: 60),
              receiveTimeout: const Duration(seconds: 60),
              headers: {
                'Content-Type': 'application/json',
              },
            )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Log the request
        print('*** Request ***');
        print('URL: ${options.uri}');
        print('Method: ${options.method}');
        print('Headers: ${options.headers}');
        if (options.data != null) {
          print('Body: ${options.data}');
        }

        // Add the token to each request if present
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

        // Verificar si la respuesta contiene un error de autenticación
        if (response.data is Map<String, dynamic> &&
            response.data['statusCode'] == 400) {
          print('Error 401: Unauthorized - Token may be expired');
          _token = null; // Limpiar el token

          // Mostrar el mensaje de error en un SnackBar
          final context = navigatorKey.currentContext;
          if (context != null) {
            final errorMessage =
                response.data['message'] ?? "Credenciales inválidas";
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }

          // Redirigir a la página de inicio de sesión
          GoRouter.of(navigatorKey.currentContext!).go(LoginPage.route);
          return; // Detener el manejo de la respuesta aquí para el error 401
        }

        // Si no es un error de autenticación, continúa con el manejo normal de la respuesta
        return handler.next(response);
      },
      onError: (error, handler) async {
        // Log the error
        print('*** Error ***');
        print('URL: ${error.requestOptions.uri}');
        print('Error: ${error.message}');
        if (error.response != null) {
          print('Status Code: ${error.response?.statusCode}');
          print('Data: ${error.response?.data}');

          // Check if the error is a 401 Unauthorized
          if (error.response?.statusCode == 401) {
            print('Error 401: Unauthorized - Token may be expired');
            // Clear the token and redirect to the login page
            _token = null;
            GoRouter.of(navigatorKey.currentContext!).go(LoginPage.route);
            return; // Stop further processing for 401
          }
        }
        return handler
            .next(error); // Continue error processing for non-401 errors
      },
    ));

    // Ignore certificates in development (for local https)
    if (_dio.httpClientAdapter is IOHttpClientAdapter) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }
  }

  // Method to set the token
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
      String errorMessage = 'Error in GET request';
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
      String errorMessage = 'Error in POST request';

      if (e.response != null && e.response?.data != null) {
        errorMessage = e.response?.data['message'] ?? errorMessage;
        print('POST $endpoint failed with status: ${e.response?.statusCode}');
        print('Response data: ${e.response?.data}');
      } else {
        print('POST $endpoint failed: ${e.message}');
      }

      throw DioException(
        requestOptions: e.requestOptions,
        error: errorMessage,
        response: e.response, // Include response for context
      );
    }
  }

  void handleError(BuildContext context, DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) {
      // If the error is 401 Unauthorized, redirect to login
      _token = null;
      GoRouter.of(navigatorKey.currentContext!).go(HomePage.route);
      return; // Return early, do not display SnackBar for 401
    }

    // Handle other errors by displaying a SnackBar with the error message
    final errorMessage = e.response?.data['message'] ?? e.message;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}
