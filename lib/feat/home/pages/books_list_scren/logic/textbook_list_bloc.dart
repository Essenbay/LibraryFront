import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_model.dart';
import 'package:libraryfront/feat/home/logic/textbook_repository.dart';

part 'textbook_list_bloc.freezed.dart';

@Injectable()
class TextbookListBloc extends Bloc<TextbookListEvent, TextbookListState> {
  final BookRepository _repository;

  TextbookListBloc(this._repository)
      : super(const TextbookListState.loading()) {
    on<TextbookListEvent>((event, emit) => event.map(
          fetch: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(Fetch event, Emitter<TextbookListState> emit) async {
    emit(const TextbookListState.loading());
    await NetworkHandler.handle(
        () async => await _repository.getTextBooks(),
        (result) => emit(TextbookListState.success(list: result)),
        (exception) =>
            emit(TextbookListState.failure(message: exception.message)));
  }
}

@freezed
class TextbookListEvent with _$TextbookListEvent {
  const factory TextbookListEvent.fetch() = Fetch;
}

@freezed
class TextbookListState with _$TextbookListState {
  const factory TextbookListState.loading() = _LoadingState;

  const factory TextbookListState.success({required List<TextBookModel> list}) =
      _SuccessState;

  const factory TextbookListState.failure({
    String? message,
  }) = _FailureState;
}
