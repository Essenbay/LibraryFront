import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libraryfront/app.dart';
import 'package:libraryfront/core/di/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  await configureDependencies();

  runApp(
    LibraryApp(),
  );
}
