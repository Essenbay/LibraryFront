import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_try_handler.dart';
import 'package:libraryfront/feat/profile/logic/profile_repository.dart';
import 'package:libraryfront/feat/profile/logic/user_model.dart';

part 'profile_bloc.freezed.dart';

@Injectable()
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository _repository;

  ProfileBloc(this._repository) : super(const ProfileState.loading()) {
    on<ProfileEvent>((event, emit) => event.map(
          fetch: (event) async => await _fetchEvent(event, emit),
        ));
  }

  Future<void> _fetchEvent(FetchEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileState.loading());
    await NetworkHandler.handle(() async => await _repository.getProfile(),
        (result) => emit(ProfileState.success(data: result)), (exception) {
      emit(ProfileState.failure(message: exception.response?.data['message']));
    });
  }
}

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.fetch() = FetchEvent;
}

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.loading() = _LoadingState;

  const factory ProfileState.success({required ProfileModel data}) =
      _SuccessState;

  const factory ProfileState.failure({
    String? message,
  }) = _FailureState;
}
