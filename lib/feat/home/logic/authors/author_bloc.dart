import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/home/logic/authors/author_repository.dart';

part 'author_bloc.freezed.dart';

@Injectable()
class AuthorEditBloc extends Bloc<AuthorEvent, AuthorState> {
  final AuthorRepository _repository;

  AuthorEditBloc(this._repository) : super(const AuthorState.initial()) {
    on<AuthorEvent>((event, emit) => event.map(
          create: (event) async => await _createEvent(event, emit),
          update: (event) async => await _updateEvent(event, emit),
          delete: (event) async => await _deleteEvent(event, emit),
        ));
  }

  Future<void> _createEvent(
      CreateEvent event, Emitter<AuthorState> emit) async {
    emit(const AuthorState.loading());
    await NetworkHandler.handle(
        () async => await _repository.createAuthor(event.author),
        (result) => emit(const AuthorState.success()),
        (exception) => emit(AuthorState.failure(message: exception.message)));
  }

  Future<void> _updateEvent(
      UpdateEvent event, Emitter<AuthorState> emit) async {
    emit(const AuthorState.loading());
    await NetworkHandler.handle(
        () async => await _repository.updateAuthor(event.id, event.author),
        (result) => emit(const AuthorState.success()),
        (exception) => emit(AuthorState.failure(message: exception.message)));
  }

  Future<void> _deleteEvent(
      DeleteEvent event, Emitter<AuthorState> emit) async {
    emit(const AuthorState.loading());
    await NetworkHandler.handle(
        () async => await _repository.deleteAuthor(event.id),
        (result) => emit(const AuthorState.success()),
        (exception) => emit(AuthorState.failure(message: exception.message)));
  }
}

@freezed
class AuthorEvent with _$AuthorEvent {
  const factory AuthorEvent.create({required AuthorRequestModel author}) =
      CreateEvent;
  const factory AuthorEvent.update(
      {required int id, required AuthorRequestModel author}) = UpdateEvent;
  const factory AuthorEvent.delete({required int id}) = DeleteEvent;
}

@freezed
class AuthorState with _$AuthorState {
  const factory AuthorState.initial() = _InitialState;
  const factory AuthorState.loading() = _LoadingState;

  const factory AuthorState.success() = _SuccessState;

  const factory AuthorState.failure({
    String? message,
  }) = _FailureState;
}
