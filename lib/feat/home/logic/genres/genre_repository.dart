import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_service.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';

@LazySingleton()
class GenreRepository {
  final NetworkService network;

  GenreRepository(this.network);

  Future<List<GenreModel>> getGenres() async {
    final response = await network.dio.get<List>('/genres');
    return response.data?.map((e) => GenreModel.fromJson(e)).toList() ?? [];
  }

  Future<GenreModel> getGenre(int id) async {
    final response = await network.dio.get('/genres/$id');
    return GenreModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> createGenre(GenreRequestModel genre) async {
    await network.dio.post('/genres', data: genre.toJson());
  }

  Future<void> updateGenre(int id, GenreRequestModel genre) async {
    await network.dio.put('/genres/$id', data: genre.toJson());
  }

  Future<void> deleteGenre(int id) async {
    await network.dio.delete('/genres/$id');
  }
}
