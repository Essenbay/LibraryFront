import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/home/logic/ebook/model_ebook.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';
import 'package:libraryfront/feat/home/logic/Ebook/Ebook_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/logic/edit_ebook_bloc.dart';

void showUpdateEBookModal(
    BuildContext conE, EBookModel initialEBook, EbookBloc bloc) async {
  final result = await showModalBottomSheet(
    context: conE,
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
            child: _UpdateEbookModal(
              initialEBook: initialEBook,
            )),
      ));
    },
  );
  if (result == true) {
    bloc.add(EbookEvent.fetch(id: initialEBook.id));
  }
}

class _UpdateEbookModal extends StatefulWidget {
  const _UpdateEbookModal({required this.initialEBook});
  final EBookModel initialEBook;
  @override
  State<_UpdateEbookModal> createState() => _UpdateEbookModalState();
}

class _UpdateEbookModalState extends State<_UpdateEbookModal> {
  late final TextEditingController _title =
      TextEditingController(text: widget.initialEBook.title);
  late final TextEditingController _format =
      TextEditingController(text: widget.initialEBook.format.toString());

  late final TextEditingController _size =
      TextEditingController(text: widget.initialEBook.size.toString());
  late AuthorModel author = widget.initialEBook.author;
  late GenreModel genre = widget.initialEBook.genre;
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
      builder: (conE, state) {
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
                  controller: _format,
                  placeholder: 'Title',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                const Text('Author', style: TextStyle(fontSize: 16)),
                DropdownButton(
                  hint: Text('${author.surname} ${author.name}'),
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
                  hint: Text(genre.name),
                  items: value.genres
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (value) => setState(() {
                    if (value != null) genre = value;
                  }),
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
                if (_errorMessage != null)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    leading: const Icon(Icons.error),
                    title: Text(_errorMessage ?? 'Error occured'),
                  ),
                ElevatedButton(
                    onPressed: () => conE.read<EditEbookBloc>().add(UpdateEvent(
                        id: widget.initialEBook.id,
                        Ebook: EbookRequest(_title.text, author.id, genre.id,
                            double.parse(_size.text), _format.text))),
                    child: const Text('Save'))
              ],
            ),
          ),
        );
      },
    );
  }
}
