import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/home/logic/authors/author_repository.dart';
import 'package:libraryfront/feat/home/logic/ebook/model_ebook.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_repository.dart';
import 'package:libraryfront/feat/home/logic/textbook_repository.dart';

part 'edit_ebook_bloc.freezed.dart';

@Injectable()
class EditEbookBloc extends Bloc<EditEbookEvent, EditEbookState> {
  final BookRepository _repository;
  final AuthorRepository _authorRepository;
  final GenreRepository _genreRepository;
  EditEbookBloc(this._repository, this._authorRepository, this._genreRepository)
      : super(const EditEbookState.initial()) {
    on<EditEbookEvent>((event, emit) => event.map(
          fetchInfo: (event) async => await _fetchEvent(event, emit),
          create: (event) async => await _createEvent(event, emit),
          update: (event) async => await _updateEvent(event, emit),
          delete: (event) async => await _deleteEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(
      FetchEvent event, Emitter<EditEbookState> emit) async {
    try {
      final authors = await _authorRepository.getAuthors();
      final genres = await _genreRepository.getGenres();
      emit(EditEbookState.fetchSuccess(authors: authors, genres: genres));
    } on DioException catch (e) {
      emit(EditEbookState.fetchFailure(e.message));
    }
  }

  Future<void> _createEvent(
      CreateEvent event, Emitter<EditEbookState> emit) async {
    await NetworkHandler.handle(
        () async => await _repository.createEBook(event.ebook),
        (result) => emit(const EditEbookState.success()),
        (exception) =>
            emit(EditEbookState.failure(message: exception.message)));
  }

  Future<void> _updateEvent(
      UpdateEvent event, Emitter<EditEbookState> emit) async {
    await NetworkHandler.handle(
        () async => await _repository.updateEBook(event.id, event.ebook),
        (result) => emit(const EditEbookState.success()),
        (exception) =>
            emit(EditEbookState.failure(message: exception.message)));
  }

  Future<void> _deleteEvent(
      DeleteEvent event, Emitter<EditEbookState> emit) async {
    await NetworkHandler.handle(
        () async => await _repository.deleteBook(event.id),
        (result) => emit(const EditEbookState.success()),
        (exception) =>
            emit(EditEbookState.failure(message: exception.message)));
  }
}

@freezed
class EditEbookEvent with _$EditEbookEvent {
  const factory EditEbookEvent.create({required EbookRequest ebook}) =
      CreateEvent;

  ///Fetches authors and genres
  const factory EditEbookEvent.fetchInfo() = FetchEvent;

  const factory EditEbookEvent.update(
      {required int id, required EbookRequest ebook}) = UpdateEvent;

  const factory EditEbookEvent.delete({required int id}) = DeleteEvent;
}

@freezed
class EditEbookState with _$EditEbookState {
  const factory EditEbookState.initial() = _InitialState;

  const factory EditEbookState.loading() = _LoadingState;

  const factory EditEbookState.fetchSuccess(
      {required List<AuthorModel> authors,
      required List<GenreModel> genres}) = _FetchInfoSuccess;

  const factory EditEbookState.success() = _EditSuccess;

  const factory EditEbookState.fetchFailure(String? message) = _FetchFailure;

  const factory EditEbookState.failure({
    String? message,
  }) = _FailureState;
}
