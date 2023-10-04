import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_service.dart';
import 'package:libraryfront/feat/auth/logic/auth_models.dart';

@LazySingleton()
class AuthRepository {
  final NetworkService network;

  AuthRepository(this.network);

  Future<AuthResponseModel> login(String email, String password) async {
    final response = await network.dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponseModel> register(RegisterRequestModel model) async {
    final response =
        await network.dio.post('/auth/registration', data: model.toJson());
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
