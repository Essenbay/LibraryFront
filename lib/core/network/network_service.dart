import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

const String baseUrl = 'http://10.0.2.2:8080';

@LazySingleton()
class NetworkService {
  NetworkService(this._dio) {
    dio.options = BaseOptions(baseUrl: baseUrl);
  }

  final Dio _dio;

  Dio get dio => _dio;
}
