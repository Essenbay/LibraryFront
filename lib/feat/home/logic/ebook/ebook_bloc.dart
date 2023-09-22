import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/ebook/model_ebook.dart';
import 'package:libraryfront/feat/home/logic/textbook_repository.dart';

part 'ebook_bloc.freezed.dart';

@Injectable()
class EbookBloc extends Bloc<EbookEvent, EbookState> {
  final BookRepository _repository;

  EbookBloc(this._repository) : super(const EbookState.loading()) {
    on<EbookEvent>((event, emit) => event.map(
          fetch: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(
      FetchEvent event, Emitter<EbookState> emit) async {
    emit(const EbookState.loading());
    await NetworkHandler.handle(
        () async => await _repository.getEBook(event.id),
        (result) => emit(EbookState.success(data: result)),
        (exception) => emit(EbookState.failure(message: exception.message)));
  }
}

@freezed
class EbookEvent with _$EbookEvent {
  const factory EbookEvent.fetch({required int id}) = FetchEvent;
}

@freezed
class EbookState with _$EbookState {
  const factory EbookState.loading() = _LoadingState;

  const factory EbookState.success({required EBookModel data}) =
      _SuccessState;

  const factory EbookState.failure({
    String? message,
  }) = _FailureState;
}
