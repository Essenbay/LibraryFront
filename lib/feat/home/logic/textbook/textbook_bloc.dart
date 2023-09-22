import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_model.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_repository.dart';

part 'textbook_bloc.freezed.dart';

@Injectable()
class TextbookBloc extends Bloc<TextbookEvent, TextbookState> {
  final BookRepository _repository;

  TextbookBloc(this._repository) : super(const TextbookState.loading()) {
    on<TextbookEvent>((event, emit) => event.map(
          fetch: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(
      FetchEvent event, Emitter<TextbookState> emit) async {
    emit(const TextbookState.loading());
    await NetworkHandler.handle(
        () async => await _repository.getTextBook(event.id),
        (result) => emit(TextbookState.success(data: result)),
        (exception) => emit(TextbookState.failure(message: exception.message)));
  }
}

@freezed
class TextbookEvent with _$TextbookEvent {
  const factory TextbookEvent.fetch({required int id}) = FetchEvent;
}

@freezed
class TextbookState with _$TextbookState {
  const factory TextbookState.loading() = _LoadingState;

  const factory TextbookState.success({required TextBookModel data}) =
      _SuccessState;

  const factory TextbookState.failure({
    String? message,
  }) = _FailureState;
}
