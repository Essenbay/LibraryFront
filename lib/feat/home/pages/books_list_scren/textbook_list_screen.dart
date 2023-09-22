import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/logic/textbook_list_bloc.dart';
import 'package:libraryfront/feat/home/pages/books_list_scren/pages/create_textbook/create_textbook_modal.dart';

class TextBookListScreen extends StatelessWidget {
  const TextBookListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TextbookListBloc, TextbookListState>(
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
                    .push(TextbookItemScreenRoute(id: state.list[index].id));
                    if(result == true)
                       context.read<TextbookListBloc>().add(const TextbookListEvent.fetch());
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
      floatingActionButton: ElevatedButton.icon(
        icon: const Icon(Icons.add),
        label: const Text('Create'),
        onPressed: () => showCreateTextBookModal(
          context,
          context.read<TextbookListBloc>(),
        ),
      ),
    );
  }
}
