import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/home/logic/ebook/model_ebook.dart';
import 'package:libraryfront/feat/home/logic/textbook_repository.dart';

part 'ebook_list_bloc.freezed.dart';

@Injectable()
class EbookListBloc extends Bloc<EbookListEvent, EbookListState> {
  final BookRepository _repository;

  EbookListBloc(this._repository)
      : super(const EbookListState.loading()) {
    on<EbookListEvent>((event, emit) => event.map(
          fetch: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(Fetch event, Emitter<EbookListState> emit) async {
    emit(const EbookListState.loading());
    await NetworkHandler.handle(
        () async => await _repository.getEBooks(),
        (result) => emit(EbookListState.success(list: result)),
        (exception) =>
            emit(EbookListState.failure(message: exception.message)));
  }
}

@freezed
class EbookListEvent with _$EbookListEvent {
  const factory EbookListEvent.fetch() = Fetch;
}

@freezed
class EbookListState with _$EbookListState {
  const factory EbookListState.loading() = _LoadingState;

  const factory EbookListState.success({required List<EBookModel> list}) =
      _SuccessState;

  const factory EbookListState.failure({
    String? message,
  }) = _FailureState;
}
