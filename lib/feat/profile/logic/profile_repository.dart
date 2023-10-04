import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/network/network_service.dart';
import 'package:libraryfront/feat/profile/logic/user_model.dart';

@Injectable()
class ProfileRepository {
  final NetworkService network;

  ProfileRepository(this.network);

  Future<ProfileModel> getProfile() async {
    final result = await network.dio.get('/profile');
    return ProfileModel.fromJson(result.data as Map<String, dynamic>);
  }
}
