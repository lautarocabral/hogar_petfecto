import 'package:hogar_petfecto/core/network/dio_client.dart';
import 'package:hogar_petfecto/core/network/repository.dart';
import 'package:hogar_petfecto/features/seguridad/data/models/seguridad_model.dart';

class SeguridadRepositoryModel extends Repository<SeguridadModel> {
  SeguridadRepositoryModel(DioClient client, String endpoint)
      : super(client, endpoint, (json) => SeguridadModel.fromJson(json));
}
