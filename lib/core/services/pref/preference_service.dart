import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/feat/profile/logic/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton()
class PreferencesService {
  final SharedPreferences _prefs;
  static const _tokenKey = 'tokenKey';
  static const _roleKey = 'roleKey';

  final StreamController<String> _tokenChangeStream =
      StreamController<String>.broadcast();
  Stream<String> get tokenChangeStream => _tokenChangeStream.stream;

  PreferencesService(this._prefs) {
    _init();
  }

  late String? _token;
  late List<Role> _roles;

  String? get token => _token;
  List<Role> get role => _roles;

  Future<void> _init() async {
    _token = _prefs.getString(_tokenKey) ?? '';
    _tokenChangeStream.add(_token!);
    _roles = _prefs
            .getStringList(_roleKey)
            ?.map((e) => $enumDecode<Role, String>(Role.enumMap, e))
            .toList() ??
        List<Role>.empty();
  }

  

  Future<void> setAuth(String token, List<Role> roles) async {
    await _prefs.setString(_tokenKey, token);
    _token = token;
    await _prefs.setStringList(_roleKey, roles.map((e) => e.str).toList());
    _roles = roles;
  }

  Future<void> deleteUser() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_roleKey);
  }
}
