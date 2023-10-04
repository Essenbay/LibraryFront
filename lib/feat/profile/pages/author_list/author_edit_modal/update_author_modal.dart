// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/core/util/ui.dart';
import 'package:libraryfront/feat/home/logic/authors/author_bloc.dart';
import 'package:libraryfront/feat/home/logic/authors/author_model.dart';
import 'package:libraryfront/feat/profile/pages/author_list/logic/author_list_bloc.dart';

void showUpdateAuthorModal(BuildContext context, AuthorModel initial) async {
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
        create: (conE) => getIt<AuthorEditBloc>(),
        child: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(conE).viewInsets.bottom),
            child: _CreateAuthorModal(initial)),
      ));
    },
  );
  if (result == true) {
    context.read<AuthorListBloc>().add(const AuthorListEvent.fetch());
  }
}

class _CreateAuthorModal extends StatefulWidget {
  const _CreateAuthorModal(this.initial);
  final AuthorModel initial;
  @override
  State<_CreateAuthorModal> createState() => _CreateAuthorModalState();
}

class _CreateAuthorModalState extends State<_CreateAuthorModal> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initial.name);
  late final TextEditingController _surname =
      TextEditingController(text: widget.initial.surname);

  String? _errorMessage;

  @override
  void dispose() {
    _name.dispose();
    _surname.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext conE) {
    return BlocConsumer<AuthorEditBloc, AuthorState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (value) => context.router.pop(true),
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
            initial: (value) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Name', style: TextStyle(fontSize: 16)),
                CupertinoTextField(
                  controller: _name,
                  placeholder: 'Name',
                ),
                const SizedBox(height: 10),
                const Text('Surname', style: TextStyle(fontSize: 16)),
                CupertinoTextField(
                  controller: _surname,
                  placeholder: 'Surname',
                  keyboardType: TextInputType.number,
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
                      if (_surname.text.isEmpty || _name.text.isEmpty) {
                        showSnackBar(context, 'Fields must not be empty');
                      } else {
                        contex.read<AuthorEditBloc>().add(AuthorEvent.update(
                            id: widget.initial.id,
                            author: AuthorRequestModel(
                              _name.text,
                              _surname.text,
                            )));
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
