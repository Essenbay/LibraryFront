import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre_model.g.dart';

@JsonSerializable(createToJson: false)
class GenreModel {
  final int id;
  final String name;

  GenreModel(this.id, this.name);

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);
}

@JsonSerializable(createFactory: false)
class GenreRequest {
  final String name;

  GenreRequest(this.name);

  Map<String, Object?> toJson() => _$GenreRequestToJson(this);
}
