import 'package:freezed_annotation/freezed_annotation.dart';

part 'author_model.g.dart';

@JsonSerializable(createToJson: false)
class AuthorModel {
  final int id;
  final String name;
  final String surname;

  AuthorModel(this.id, this.name, this.surname);
  factory AuthorModel.fromJson(Map<String, Object?> json) =>
      _$AuthorModelFromJson(json);
}

@JsonSerializable(createFactory: false)
class AuthorRequestModel {
  final String name;
  final String surname;

  AuthorRequestModel(this.name, this.surname);

  Map<String, Object?> toJson() => _$AuthorRequestModelToJson(this);
}
