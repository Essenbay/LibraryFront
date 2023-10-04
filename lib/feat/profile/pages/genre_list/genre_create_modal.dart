import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/core/util/ui.dart';
import 'package:libraryfront/feat/home/logic/genres/genre_model.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/logic/genre_edit_bloc.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/logic/genre_list_bloc.dart';

void showCreateGenreModal(BuildContext context, GenreListBloc bloc) async {
  final editBloc = getIt<EditGenreBloc>();
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
    bloc.add(const GenreListEvent.fetch());
  }
}

class _CreateTextbookModal extends StatefulWidget {
  const _CreateTextbookModal();
  @override
  State<_CreateTextbookModal> createState() => _CreateTextbookModalState();
}

class _CreateTextbookModalState extends State<_CreateTextbookModal> {
  late final TextEditingController _title = TextEditingController();

  String? _errorMessage;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditGenreBloc, EditGenreState>(
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
            initial: (value) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Title', style: TextStyle(fontSize: 16)),
                CupertinoTextField(
                  controller: _title,
                  placeholder: 'Title',
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
                      if (_title.text.isEmpty) {
                        showSnackBar(context, 'Fields must not be empty');
                      } else {
                        context.read<EditGenreBloc>().add(EditGenreEvent.create(
                            genre: GenreRequestModel(_title.text)));
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
