import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/services/pref/preference_service.dart';

const String baseUrl = 'http://10.0.2.2:8080';

@LazySingleton()
class NetworkService {
  final PreferencesService _prefs;
  NetworkService(this._dio, this._prefs) {
    dio.options = BaseOptions(baseUrl: baseUrl);
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer ${_prefs.token}';
        handler.next(options);
      },
    ));
    _dio.options.headers.addAll({
      'Accept': 'application/json',
    });
  }
  
  final Dio _dio;

  Dio get dio => _dio;
}
