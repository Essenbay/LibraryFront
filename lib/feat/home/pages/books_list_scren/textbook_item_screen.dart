import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/feat/home/logic/textbook/textbook_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/logic/edit_textbook_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/update_textbook_modal.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/widgets/textbook_bloc_wrapper.dart';
import 'package:libraryfront/feat/home/widgets/back_app_bar.dart';
import 'package:libraryfront/core/util/ui.dart';
import 'package:libraryfront/feat/home/widgets/crud_widget.dart';

class TextbookItemScreen extends StatelessWidget {
  const TextbookItemScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return TextbookBlocWrapper(
      id: id,
      child: BlocBuilder<TextbookBloc, TextbookState>(
        builder: (context, state) {
          return Scaffold(
            appBar: BackIconLeadingAppBar(
              actions: [
                CrudWidget(
                  child: BlocListener<EditTextbookBloc, EditTextbookState>(
                    listener: (context, editState) {
                      editState.mapOrNull(
                        success: (value) => context.router.pop(true),
                        failure: (value) =>
                            showSnackBar(context, value.message),
                      );
                    },
                    child: IconButton(
                        onPressed: () => context
                            .read<EditTextbookBloc>()
                            .add(EditTextbookEvent.delete(id: id)),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ),
                )
              ],
            ),
            body: state.maybeMap(
              orElse: () => const Center(
                child: CircularProgressIndicator(),
              ),
              failure: (state) => Center(
                child: Text(state.message ?? 'Error occured'),
              ),
              success: (state) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      state.data.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Author: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(
                            '${state.data.author.surname} ${state.data.author.name}',
                            style: const TextStyle(fontSize: 16))
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Genre: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(state.data.genre.name,
                            style: const TextStyle(fontSize: 16))
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Edition: ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        Text(state.data.edition.toString(),
                            style: const TextStyle(fontSize: 16))
                      ],
                    ),
                    Text(
                      state.data.available ? 'Available' : 'Not available',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: state.maybeMap(
              success: (value) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CrudWidget(
                      child: ElevatedButton(
                        onPressed: () => showUpdateTextBookModal(
                            context, value.data, context.read<TextbookBloc>()),
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              orElse: () => const SizedBox(),
            ),
          );
        },
      ),
    );
  }
}
