import 'package:flutter/material.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/core/services/auth_status/app_cubit.dart';
import 'package:libraryfront/core/util/themes.dart';
import 'package:provider/provider.dart';

class LibraryApp extends StatelessWidget {
  LibraryApp({super.key});

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<AppStateCubit>(),
      child: MaterialApp.router(
        title: 'Library',
        theme: AppTheme.lightTheme.copyWith(
          primaryColor: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        locale: const Locale('en'),
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate:
            _appRouter.delegate(initialRoutes: [const MainScreenRoute()]),
      ),
    );
  }
}
