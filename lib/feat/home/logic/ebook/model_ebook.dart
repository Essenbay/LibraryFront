import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';

part 'model_ebook.g.dart';

@JsonSerializable(createToJson: false)
class EBookModel {
  final int id;
  final String title;
  final AuthorModel author;
  final GenreModel genre;
  final double size;
  final String format;

  factory EBookModel.fromJson(Map<String, dynamic> json) =>
      _$EBookModelFromJson(json);

  EBookModel(
      this.id, this.title, this.author, this.genre, this.size, this.format);
}

@JsonSerializable(createFactory: false)
class EbookRequest {
  final String title;
  final int authorId;
  final int genreId;
  final double size;
  final String format;

  EbookRequest(this.title, this.authorId, this.genreId, this.size, this.format);

  Map<String, Object?> toJson() => _$EbookRequestToJson(this);
}
