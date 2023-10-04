import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_repository.dart';

part 'genre_list_bloc.freezed.dart';

@Injectable()
class GenreListBloc extends Bloc<GenreListEvent, GenreListState> {
  final GenreRepository _repository;

  GenreListBloc(this._repository)
      : super(const GenreListState.loading()) {
    on<GenreListEvent>((event, emit) => event.map(
          fetch: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(Fetch event, Emitter<GenreListState> emit) async {
    emit(const GenreListState.loading());
    await NetworkHandler.handle(
        () async => await _repository.getGenres(),
        (result) => emit(GenreListState.success(list: result)),
        (exception) =>
            emit(GenreListState.failure(message: exception.message)));
  }
}

@freezed
class GenreListEvent with _$GenreListEvent {
  const factory GenreListEvent.fetch() = Fetch;
}

@freezed
class GenreListState with _$GenreListState {
  const factory GenreListState.loading() = _LoadingState;

  const factory GenreListState.success({required List<GenreModel> list}) =
      _SuccessState;

  const factory GenreListState.failure({
    String? message,
  }) = _FailureState;
}
