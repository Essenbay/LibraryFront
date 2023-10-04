import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/feat/home/logic/authors/author_bloc.dart';
import 'package:libraryfront/feat/profile/pages/author_list/logic/author_list_bloc.dart';

class AuthorBlocWrapper extends StatelessWidget {
  const AuthorBlocWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthorEditBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<AuthorListBloc>()..add(const AuthorListEvent.fetch()),
        ),
      ],
      child: child,
    );
  }
}
