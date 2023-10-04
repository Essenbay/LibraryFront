import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_service.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';

@LazySingleton()
class AuthorRepository {
  final NetworkService network;

  AuthorRepository(this.network);

  Future<List<AuthorModel>> getAuthors() async {
    final response = await network.dio.get<List>('/authors');
    return response.data?.map((e) => AuthorModel.fromJson(e)).toList() ?? [];
  }

  Future<AuthorModel> getAuthor(int id) async {
    final response = await network.dio.get('/authors/$id');
    return AuthorModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createAuthor(AuthorRequestModel author) async {
    await network.dio.post('/authors', data: author.toJson());
  }

  Future<void> updateAuthor(int id, AuthorRequestModel authorModel) async {
    await network.dio.put('/authors/$id', data: authorModel.toJson());
  }

  Future<void> deleteAuthor(int id) async {
    await network.dio.delete('/authors/$id');
  }
}
