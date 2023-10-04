import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/logic/genre_edit_bloc.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/logic/genre_list_bloc.dart';

class GenreListBlocWrapper extends StatelessWidget {
  const GenreListBlocWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<EditGenreBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<GenreListBloc>()..add(const GenreListEvent.fetch()),
        ),
      ],
      child: Builder(builder: (context) {
        return child;
      }),
    );
  }
}
