import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/core/util/ui.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/home/logic/ebook/model_ebook.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/logic/ebook_list_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/logic/edit_ebook_bloc.dart';

void showCreateEBookModal(BuildContext context, EbookListBloc bloc) async {
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
    builder: (BuildContext conE) {
      return IntrinsicHeight(
          child: BlocProvider(
        create: (conE) =>
            getIt<EditEbookBloc>()..add(const EditEbookEvent.fetchInfo()),
        child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(conE).viewInsets.bottom),
            child: const _CreateEbookModal()),
      ));
    },
  );
  if (result == true) {
    bloc.add(const EbookListEvent.fetch());
  }
}

class _CreateEbookModal extends StatefulWidget {
  const _CreateEbookModal();
  @override
  State<_CreateEbookModal> createState() => _CreateEbookModalState();
}

class _CreateEbookModalState extends State<_CreateEbookModal> {
  late final TextEditingController _title = TextEditingController();
  late final TextEditingController _format = TextEditingController();

  late final TextEditingController _size = TextEditingController();
  AuthorModel? author;
  GenreModel? genre;
  String? _errorMessage;

  @override
  void dispose() {
    _title.dispose();
    _format.dispose();
    _size.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext conE) {
    return BlocConsumer<EditEbookBloc, EditEbookState>(
      listener: (conE, state) {
        state.mapOrNull(
          success: (value) => conE.router.pop(true),
          failure: (value) => setState(() => _errorMessage = value.message),
        );
      },
      buildWhen: (previous, current) =>
          current.maybeMap(failure: (value) => false, orElse: () => true),
      builder: (contex, state) {
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
                const Text('Format', style: TextStyle(fontSize: 16)),
                CupertinoTextField(
                  controller: _format,
                  placeholder: 'Title',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                const Text('Size', style: TextStyle(fontSize: 16)),
                CupertinoTextField(
                  controller: _size,
                  placeholder: 'Size',
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}$')),
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
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
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    leading: const Icon(Icons.error),
                    title: Text(_errorMessage ?? 'Error occured'),
                  ),
                ElevatedButton(
                    onPressed: () {
                      if (_format.text.isEmpty ||
                          _size.text.isEmpty ||
                          _title.text.isEmpty ||
                          author == null ||
                          genre == null) {
                        showSnackBar(context, 'Fields must not be empty');
                      } else {
                        contex.read<EditEbookBloc>().add(CreateEvent(
                            ebook: EbookRequest(
                                _title.text,
                                author!.id,
                                genre!.id,
                                double.parse(_size.text),
                                _format.text)));
                      }
                    },
                    child: const Text('Save'))
              ],
            ),
          ),
        );
      },
    );
  }
}
