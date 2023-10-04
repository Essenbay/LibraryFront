import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_repository.dart';

part 'genre_edit_bloc.freezed.dart';

@Injectable()
class EditGenreBloc extends Bloc<EditGenreEvent, EditGenreState> {
  final GenreRepository _repository;
  EditGenreBloc(this._repository) : super(const EditGenreState.initial()) {
    on<EditGenreEvent>((event, emit) => event.map(
          create: (event) async => await _createEvent(event, emit),
          update: (event) async => await _updateEvent(event, emit),
          delete: (event) async => await _deleteEvent(event, emit),
        ));
  }

  Future<void> _createEvent(
      CreateEvent event, Emitter<EditGenreState> emit) async {
    emit(const EditGenreState.loading());
    await NetworkHandler.handle(
        () async => await _repository.createGenre(event.genre),
        (result) => emit(const EditGenreState.success()),
        (exception) =>
            emit(EditGenreState.failure(message: exception.message)));
  }

  Future<void> _updateEvent(
      UpdateEvent event, Emitter<EditGenreState> emit) async {
    emit(const EditGenreState.loading());
    await NetworkHandler.handle(
        () async => await _repository.updateGenre(event.id, event.genre),
        (result) => emit(const EditGenreState.success()),
        (exception) =>
            emit(EditGenreState.failure(message: exception.message)));
  }

  Future<void> _deleteEvent(
      DeleteEvent event, Emitter<EditGenreState> emit) async {
    emit(const EditGenreState.loading());
    await NetworkHandler.handle(
        () async => await _repository.deleteGenre(event.id),
        (result) => emit(const EditGenreState.success()),
        (exception) =>
            emit(EditGenreState.failure(message: exception.message)));
  }
}

@freezed
class EditGenreEvent with _$EditGenreEvent {
  const factory EditGenreEvent.create({required GenreRequestModel genre}) =
      CreateEvent;

  ///Fetches authors and genres

  const factory EditGenreEvent.update(
      {required int id, required GenreRequestModel genre}) = UpdateEvent;

  const factory EditGenreEvent.delete({required int id}) = DeleteEvent;
}

@freezed
class EditGenreState with _$EditGenreState {
  const factory EditGenreState.initial() = _InitialState;

  const factory EditGenreState.loading() = _LoadingState;

  const factory EditGenreState.success() = _EditSuccess;

  const factory EditGenreState.failure({
    String? message,
  }) = _FailureState;
}
