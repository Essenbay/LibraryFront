import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:libraryfront/feat/profile/logic/user_model.dart';

part 'auth_models.g.dart';

@JsonSerializable(createFactory: false)
class RegisterRequestModel {
  final String email;
  final String username;
  final String password;
  final String confirmPassword;

  RegisterRequestModel(
      this.username, this.email, this.password, this.confirmPassword);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);
}

@JsonSerializable(createToJson: false)
class AuthResponseModel {
  final String token;
  final List<Role> role;

  AuthResponseModel(this.token, this.role);

  factory AuthResponseModel.fromJson(Map<String, Object?> json) =>
      _$AuthResponseModelFromJson(json);
}
