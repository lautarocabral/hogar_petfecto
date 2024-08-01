// seguridad_repository.dart

import 'package:hogar_petfecto/core/network/api_response.dart';
import 'package:hogar_petfecto/core/network/dio_client.dart';
import 'package:hogar_petfecto/core/network/repository.dart';
import 'package:hogar_petfecto/features/seguridad/data/models/login_response_model.dart';
import 'package:hogar_petfecto/features/seguridad/data/models/seguridad_model.dart';

class SeguridadRepositoryModel extends Repository<SeguridadModel> {
  SeguridadRepositoryModel(DioClient client, String endpoint)
      : super(client, endpoint, (json) => SeguridadModel.fromJson(json));

  Future<ApiResponse<LoginResponseModel>> loginUser(
      Map<String, dynamic> data) async {
    try {
      final response = await client.post('$endpoint/login', data: data);
      return ApiResponse.fromJson(
          response.data, (json) => LoginResponseModel.fromJson(json));
    } catch (e) {
      return ApiResponse(success: false, message: e.toString());
    }
  }
}
