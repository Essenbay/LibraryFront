import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/home/logic/authors/author_repository.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_repository.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_model.dart';
import 'package:libraryfront/feat/home/logic/textbook_repository.dart';

part 'edit_textbook_bloc.freezed.dart';

@Injectable()
class EditTextbookBloc extends Bloc<EditTextbookEvent, EditTextbookState> {
  final BookRepository _repository;
  final AuthorRepository _authorRepository;
  final GenreRepository _genreRepository;
  EditTextbookBloc(
      this._repository, this._authorRepository, this._genreRepository)
      : super(const EditTextbookState.initial()) {
    on<EditTextbookEvent>((event, emit) => event.map(
          fetchInfo: (event) async => await _fetchEvent(event, emit),
          create: (event) async => await _createEvent(event, emit),
          update: (event) async => await _updateEvent(event, emit),
          delete: (event) async => await _deleteEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(
      FetchEvent event, Emitter<EditTextbookState> emit) async {
    emit(const EditTextbookState.loading());
    try {
      final authors = await _authorRepository.getAuthors();
      final genres = await _genreRepository.getGenres();
      emit(EditTextbookState.fetchSuccess(authors: authors, genres: genres));
    } on DioException catch (e) {
      emit(EditTextbookState.fetchFailure(e.message));
    }
  }

  Future<void> _createEvent(
      CreateEvent event, Emitter<EditTextbookState> emit) async {
    emit(const EditTextbookState.loading());
    await NetworkHandler.handle(
        () async => await _repository.createTextBook(event.textbook),
        (result) => emit(const EditTextbookState.success()),
        (exception) =>
            emit(EditTextbookState.failure(message: exception.message)));
  }

  Future<void> _updateEvent(
      UpdateEvent event, Emitter<EditTextbookState> emit) async {
    emit(const EditTextbookState.loading());
    await NetworkHandler.handle(
        () async => await _repository.updateTextBook(event.id, event.textbook),
        (result) => emit(const EditTextbookState.success()),
        (exception) =>
            emit(EditTextbookState.failure(message: exception.message)));
  }

  Future<void> _deleteEvent(
      DeleteEvent event, Emitter<EditTextbookState> emit) async {
    emit(const EditTextbookState.loading());
    await NetworkHandler.handle(
        () async => await _repository.deleteBook(event.id),
        (result) => emit(const EditTextbookState.success()),
        (exception) =>
            emit(EditTextbookState.failure(message: exception.message)));
  }
}

@freezed
class EditTextbookEvent with _$EditTextbookEvent {
  const factory EditTextbookEvent.create({required TextbookRequest textbook}) =
      CreateEvent;

  ///Fetches authors and genres
  const factory EditTextbookEvent.fetchInfo() = FetchEvent;

  const factory EditTextbookEvent.update(
      {required int id, required TextbookRequest textbook}) = UpdateEvent;

  const factory EditTextbookEvent.delete({required int id}) = DeleteEvent;
}

@freezed
class EditTextbookState with _$EditTextbookState {
  const factory EditTextbookState.initial() = _InitialState;

  const factory EditTextbookState.loading() = _LoadingState;

  const factory EditTextbookState.fetchSuccess(
      {required List<AuthorModel> authors,
      required List<GenreModel> genres}) = _FetchInfoSuccess;

  const factory EditTextbookState.success() = _EditSuccess;

  const factory EditTextbookState.fetchFailure(String? message) = _FetchFailure;

  const factory EditTextbookState.failure({
    String? message,
  }) = _FailureState;
}
