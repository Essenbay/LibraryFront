import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/home/logic/authors/author_repository.dart';

part 'author_list_bloc.freezed.dart';

@Injectable()
class AuthorListBloc extends Bloc<AuthorListEvent, AuthorListState> {
  final AuthorRepository _repository;

  AuthorListBloc(this._repository)
      : super(const AuthorListState.loading()) {
    on<AuthorListEvent>((event, emit) => event.map(
          fetch: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(Fetch event, Emitter<AuthorListState> emit) async {
    emit(const AuthorListState.loading());
    await NetworkHandler.handle(
        () async => await _repository.getAuthors(),
        (result) => emit(AuthorListState.success(list: result)),
        (exception) =>
            emit(AuthorListState.failure(message: exception.message)));
  }
}

@freezed
class AuthorListEvent with _$AuthorListEvent {
  const factory AuthorListEvent.fetch() = Fetch;
}

@freezed
class AuthorListState with _$AuthorListState {
  const factory AuthorListState.loading() = _LoadingState;

  const factory AuthorListState.success({required List<AuthorModel> list}) =
      _SuccessState;

  const factory AuthorListState.failure({
    String? message,
  }) = _FailureState;
}
