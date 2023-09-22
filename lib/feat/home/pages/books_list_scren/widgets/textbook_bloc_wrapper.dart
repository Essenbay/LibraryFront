import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/logic/edit_textbook_bloc.dart';

class TextbookBlocWrapper extends StatelessWidget {
  const TextbookBlocWrapper({super.key, required this.child, required this.id});
  final Widget child;
  final int id;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<TextbookBloc>()..add(TextbookEvent.fetch(id: id)),
        ),
        BlocProvider(
          create: (context) => EditTextbookBloc(getIt(), getIt(), getIt()),
        ),
      ],
      child: child,
    );
  }
}
