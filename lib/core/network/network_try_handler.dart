import 'package:dio/dio.dart';

class NetworkHandler {
  static Future<void> handle<K>(
    Future<K> Function() body,
    Function(K result) onSuccess,
    Function(DioException exception) onError,
  ) async {
    try {
      final result = await body();
      await onSuccess(result);
    } on DioException catch (err) {
      onError(err);
    } on Object catch (e, _) {
      onError(DioException.badResponse(
          statusCode: 400,
          requestOptions: RequestOptions(),
          response: Response(
              requestOptions: RequestOptions(), statusMessage: e.toString())));
    }
  }
}
