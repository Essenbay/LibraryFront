import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/auth/logic/auth_repository.dart';
import 'package:libraryfront/feat/profile/logic/user_model.dart';

part 'login_bloc.freezed.dart';

@Injectable()
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _repository;

  LoginBloc(this._repository) : super(const LoginState.loading()) {
    on<LoginEvent>((event, emit) => event.map(
          login: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(FetchEvent event, Emitter<LoginState> emit) async {
    emit(const LoginState.loading());
    await NetworkHandler.handle(
        () async => await _repository.login(event.email, event.password),
        (result) =>
            emit(LoginState.success(token: result.token, role: result.role)),
        (exception) => emit(LoginState.failure(message: exception.message)));
  }
}

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.login(
      {required String email, required String password}) = FetchEvent;
}

@freezed
class LoginState with _$LoginState {
  const factory LoginState.loading() = _LoadingState;

  const factory LoginState.success(
      {required String token, required List<Role> role}) = _SuccessState;

  const factory LoginState.failure({
    String? message,
  }) = _FailureState;
}
