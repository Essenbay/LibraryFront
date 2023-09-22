import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:libraryfront/core/di/injection_container.config.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  const securedStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true));
  getIt.registerLazySingleton<FlutterSecureStorage>(() => securedStorage);
  final dio = Dio();
  getIt.registerLazySingleton<Dio>(() => dio);
  final pref = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => pref);

  getIt.init();
}
