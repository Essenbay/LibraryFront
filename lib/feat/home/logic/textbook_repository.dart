import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_service.dart';
import 'package:libraryfront/feat/home/logic/ebook/model_ebook.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_model.dart';

@LazySingleton()
class BookRepository {
  final NetworkService network;

  BookRepository(this.network);

  Future<List<TextBookModel>> getTextBooks() async {
    final response = await network.dio.get<List>('/books/textbooks');
    return response.data?.map((e) => TextBookModel.fromJson(e)).toList() ?? [];
  }

  Future<TextBookModel> getTextBook(int id) async {
    final response = await network.dio.get('/books/textbooks/$id');
    return TextBookModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createTextBook(TextbookRequest textbook) async {
    await network.dio.post('/books/textbooks', data: textbook.toJson());
  }

  Future<void> updateTextBook(int id, TextbookRequest textbookRequest) async {
    await network.dio
        .put('/books/textbooks/$id', data: textbookRequest.toJson());
  }

  Future<void> deleteBook(int id) async {
    await network.dio.delete('/books/$id');
  }

  Future<List<EBookModel>> getEBooks() async {
    final response = await network.dio.get<List>('/books/ebooks');
    return response.data?.map((e) => EBookModel.fromJson(e)).toList() ?? [];
  }

  Future<EBookModel> getEBook(int id) async {
    final response = await network.dio.get('/books/ebooks/$id');
    return EBookModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createEBook(EbookRequest book) async {
    await network.dio.post('/books/ebooks', data: book.toJson());
  }

  Future<void> updateEBook(int id, EbookRequest book) async {
    await network.dio.put('/books/ebooks/$id', data: book.toJson());
  }
}
