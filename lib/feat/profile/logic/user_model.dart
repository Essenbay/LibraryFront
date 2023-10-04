import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_model.g.dart';

enum Role {
  @JsonValue('ROLE_ADMIN')
  admin('ROLE_ADMIN'),
  @JsonValue('ROLE_CUSTOMER')
  customer('ROLE_CUSTOMER');

  final String str;
  const Role(this.str);

  static Map<Role, String> enumMap = {
    Role.admin: 'ROLE_ADMIN',
    Role.customer: 'ROLE_CUSTOMER',
  };
}

@JsonSerializable(createToJson: false)
class ProfileModel {
  final int id;
  final String name;
  final String email;

  ProfileModel(this.id, this.name, this.email);

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
