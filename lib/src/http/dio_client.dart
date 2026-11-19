import 'package:dio/dio.dart';

class DioClient {
  static final Dio instance = Dio(BaseOptions(
    baseUrl: 'https://viacep.com.br/ws',
    connectTimeout: 12000,
    receiveTimeout: 12000,
    sendTimeout: 12000,
    responseType: ResponseType.json,
    headers: {'Accept': 'application/json'},
  ));
}
