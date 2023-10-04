import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/feat/home/logic/ebook/bloc_ebook.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_Ebook/update_Ebook_modal.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/update_textbook/logic/edit_ebook_bloc.dart';
import 'package:libraryfront/feat/home/pages/ebook_list_screen/ebook_bloc_wrapper.dart';
import 'package:libraryfront/feat/home/widgets/back_app_bar.dart';
import 'package:libraryfront/feat/home/widgets/crud_widget.dart';

class EbookItemScreen extends StatelessWidget {
  const EbookItemScreen({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return EbookBlocWrapper(
      id: id,
      child: BlocBuilder<EbookBloc, EbookState>(
        builder: (context, state) {
          return Scaffold(
            appBar: BackIconLeadingAppBar(
              actions: [
                CrudWidget(
                  child: BlocListener<EditEbookBloc, EditEbookState>(
                    listener: (context, state) {
                      state.mapOrNull(
                        success: (value) => context.router.pop(true),
                      );
                    },
                    child: IconButton(
                        onPressed: () => context
                            .read<EditEbookBloc>()
                            .add(EditEbookEvent.delete(id: id)),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ),
                )
              ],
            ),
            body: BlocBuilder<EbookBloc, EbookState>(
              builder: (context, state) => state.maybeMap(
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
                          const Text('Format: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          Text(state.data.format,
                              style: const TextStyle(fontSize: 16))
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Size: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                          Text(state.data.size.toString(),
                              style: const TextStyle(fontSize: 16))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: BlocBuilder<EbookBloc, EbookState>(
              builder: (context, state) {
                return state.maybeMap(
                  success: (value) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CrudWidget(
                          child: ElevatedButton(
                            onPressed: () => showUpdateEBookModal(
                                context, value.data, context.read<EbookBloc>()),
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
                );
              },
            ),
          );
        },
      ),
    );
  }
}
