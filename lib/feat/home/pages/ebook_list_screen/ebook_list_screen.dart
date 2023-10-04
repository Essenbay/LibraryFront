// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/logic/ebook_list_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/create_ebook/create_ebook_modal.dart';
import 'package:libraryfront/feat/home/widgets/crud_widget.dart';

class EbookListScreen extends StatelessWidget {
  const EbookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EbookListBloc, EbookListState>(
        builder: (context, state) {
          return state.maybeMap(
            orElse: () => const Center(child: CircularProgressIndicator()),
            failure: (state) => Center(
              child: Text(state.message ?? 'Error occured'),
            ),
            success: (state) => ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () async {
                  final result = await context.router
                      .push(EbookItemScreenRoute(id: state.list[index].id));
                  if (result == true) {
                    context
                        .read<EbookListBloc>()
                        .add(const EbookListEvent.fetch());
                  }
                },
                child: ListTile(
                  leading: Text(state.list[index].id.toString()),
                  title: Text(state.list[index].title),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: CrudWidget(
          child: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Create'),
        onPressed: () => showCreateEBookModal(
          context,
          context.read<EbookListBloc>(),
        ),
      )),
    );
  }
}
