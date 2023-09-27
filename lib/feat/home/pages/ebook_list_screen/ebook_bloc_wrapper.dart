import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/feat/home/logic/ebook/bloc_ebook.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/logic/edit_ebook_bloc.dart';

class EbookBlocWrapper extends StatelessWidget {
  const EbookBlocWrapper({super.key, required this.child, required this.id});
  final Widget child;
  final int id;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<EbookBloc>()..add(EbookEvent.fetch(id: id)),
        ),
        BlocProvider(
          create: (context) => EditEbookBloc(getIt(), getIt(), getIt()),
        ),
      ],
      child: child,
    );
  }
}
