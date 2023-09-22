import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/core/util/ui.dart';
import 'package:libraryfront/feat/home/logic/author_model.dart';
import 'package:libraryfront/feat/home/logic/genre_model.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_model.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/logic/textbook_list_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/logic/edit_textbook_bloc.dart';

void showCreateTextBookModal(
    BuildContext context, TextbookListBloc bloc) async {
  final editBloc = getIt<EditTextbookBloc>()
    ..add(const EditTextbookEvent.fetchInfo());
  final result = await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
    ),
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    builder: (BuildContext context) {
      return IntrinsicHeight(
          child: BlocProvider.value(
        value: editBloc,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const _CreateTextbookModal()),
      ));
    },
  );
  if (result == true) {
    bloc.add(const TextbookListEvent.fetch());
  }
}

class _CreateTextbookModal extends StatefulWidget {
  const _CreateTextbookModal();
  @override
  State<_CreateTextbookModal> createState() => _CreateTextbookModalState();
}

class _CreateTextbookModalState extends State<_CreateTextbookModal> {
  late final TextEditingController _title = TextEditingController();
  late final TextEditingController _edition = TextEditingController(text: '1');
  AuthorModel? author;
  GenreModel? genre;
  bool isAvailable = true;
  String? _errorMessage;

  @override
  void dispose() {
    _title.dispose();
    _edition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditTextbookBloc, EditTextbookState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (value) => context.router.pop(true),
          failure: (value) => setState(() => _errorMessage = value.message),
        );
      },
      buildWhen: (previous, current) =>
          current.maybeMap(failure: (value) => false, orElse: () => true),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: state.maybeMap(
            orElse: () => const Center(
              child: CircularProgressIndicator(),
            ),
            fetchFailure: (value) => Center(
              child: Text(value.message ?? 'Error occured'),
            ),
            fetchSuccess: (value) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Title', style: TextStyle(fontSize: 16)),
                CupertinoTextField(
                  controller: _title,
                  placeholder: 'Title',
                ),
                const SizedBox(height: 10),
                const Text('Edition', style: TextStyle(fontSize: 16)),
                CupertinoTextField(
                  controller: _edition,
                  placeholder: 'Title',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                const Text('Author', style: TextStyle(fontSize: 16)),
                DropdownButton(
                  hint: Text('${author?.surname ?? ''} ${author?.name ?? ''}'),
                  items: value.authors
                      .map((e) => DropdownMenuItem(
                          value: e, child: Text('${e.surname} ${e.name}')))
                      .toList(),
                  onChanged: (value) => setState(() {
                    if (value != null) author = value;
                  }),
                ),
                const SizedBox(height: 10),
                const Text('Genre', style: TextStyle(fontSize: 16)),
                DropdownButton(
                  hint: Text(genre?.name ?? ''),
                  items: value.genres
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    if (value != null) genre = value;
                  }),
                ),
                CheckboxListTile(
                    title: const Text('Is available?',
                        style: TextStyle(fontSize: 16)),
                    value: isAvailable,
                    onChanged: (value) => setState(() {
                          if (value != null) {
                            isAvailable = value;
                          }
                        })),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    leading: const Icon(Icons.error),
                    title: Text(_errorMessage ?? 'Error occured'),
                  ),
                ElevatedButton(
                    onPressed: () {
                      if (_title.text.isEmpty ||
                          author == null ||
                          genre == null ||
                          _edition.text.isEmpty) {
                        showSnackBar(context, 'Fields must not be empty');
                      } else {
                        context.read<EditTextbookBloc>().add(CreateEvent(
                            textbook: TextbookRequest(
                                _title.text,
                                author!.id,
                                genre!.id,
                                int.parse(_edition.text),
                                isAvailable)));
                      }
                    },
                    child: const Text('Create'))
              ],
            ),
          ),
        );
      },
    );
  }
}
