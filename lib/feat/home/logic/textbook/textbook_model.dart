import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:libraryfront/feat/home/logic/author_model.dart';
import 'package:libraryfront/feat/home/logic/genre_model.dart';

part 'textbook_model.g.dart';

@JsonSerializable(createToJson: false)
class TextBookModel {
  final int id;
  final String title;
  final AuthorModel author;
  final GenreModel genre;
  final int edition;
  final bool available;

  TextBookModel(this.id, this.title, this.author, this.genre, this.edition,
      this.available);

  factory TextBookModel.fromJson(Map<String, dynamic> json) =>
      _$TextBookModelFromJson(json);
}

@JsonSerializable(createFactory: false)
class TextbookRequest {
  final String title;
  final int authorId;
  final int genreId;
  final int edition;
  final bool available;

  TextbookRequest(
      this.title, this.authorId, this.genreId, this.edition, this.available);

  Map<String, Object?> toJson() => _$TextbookRequestToJson(this);
}
