import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/auth/logic/auth_models.dart';
import 'package:libraryfront/feat/auth/logic/auth_repository.dart';
import 'package:libraryfront/feat/profile/logic/user_model.dart';

part 'register_bloc.freezed.dart';

@Injectable()
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _repository;

  RegisterBloc(this._repository) : super(const RegisterState.loading()) {
    on<RegisterEvent>((event, emit) => event.map(
          register: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(
      FetchEvent event, Emitter<RegisterState> emit) async {
    emit(const RegisterState.loading());
    await NetworkHandler.handle(
        () async => await _repository.register(event.model),
        (result) =>
            emit(RegisterState.success(token: result.token, role: result.role)),
        (exception) => emit(RegisterState.failure(message: exception.message)));
  }
}

@freezed
class RegisterEvent with _$RegisterEvent {
  const factory RegisterEvent.register(RegisterRequestModel model) = FetchEvent;
}

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.loading() = _LoadingState;

  const factory RegisterState.success(
      {required String token, required List<Role> role}) = _SuccessState;

  const factory RegisterState.failure({
    String? message,
  }) = _FailureState;
}
