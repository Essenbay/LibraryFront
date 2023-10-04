import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/services/pref/preference_service.dart';
import 'package:libraryfront/feat/profile/logic/user_model.dart';

enum AppState {
  authenticated,
  unauthenticated,
}

@LazySingleton()
class AppStateCubit extends ChangeNotifier {
  AppStateCubit(this._prefs) : super() {
    if (_prefs.token?.isEmpty ?? false) {
      authState = AppState.unauthenticated;
      isAdmin = false;
      isClient = false;
    } else {
      authState = AppState.authenticated;
      isAdmin = _prefs.role.contains(Role.admin);
      isClient = _prefs.role.contains(Role.customer);
    }
    notifyListeners();
  }

  final PreferencesService _prefs;
  AppState authState = AppState.authenticated;

  late bool isAdmin;
  late bool isClient;

  void setAuth(String token, List<Role> roles) {
    _prefs.setAuth(token, roles);
    authState = AppState.authenticated;
    isAdmin = roles.contains(Role.admin);
    isClient = roles.contains(Role.customer);
    notifyListeners();
  }

  void setUnauth() {
    _prefs.deleteUser();
    authState = AppState.unauthenticated;
    isAdmin = false;
    isClient = false;
    notifyListeners();
  }
}
