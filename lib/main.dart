import 'package:flutter/material.dart';
import 'package:libraryfront/app.dart';
import 'package:libraryfront/core/bloc/bloc_observer.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  Bloc.observer = AppBlocObserver();
  Bloc.transformer = bloc_concurrency.sequential<Object?>();
  runApp(
    LibraryApp(),
  );
}
