import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/feat/home/widgets/back_app_bar.dart';
import 'package:libraryfront/feat/home/widgets/crud_widget.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/genre_create_modal.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/genre_update_modal.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/logic/genre_edit_bloc.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/logic/genre_list_bloc.dart';
import 'package:libraryfront/feat/profile/pages/genre_list/widgets/genre_list_bloc_wrapper.dart';

class GenreListScreen extends StatelessWidget {
  const GenreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenreListBlocWrapper(
      child: Scaffold(
        appBar: const BackIconLeadingAppBar(),
        body: BlocListener<EditGenreBloc, EditGenreState>(
          listener: (context, state) {
            state.mapOrNull(success: (state) {
              context.read<GenreListBloc>().add(const GenreListEvent.fetch());
            });
          },
          child: BlocBuilder<GenreListBloc, GenreListState>(
            builder: (context, state) {
              return state.maybeMap(
                orElse: () => const Center(child: CircularProgressIndicator()),
                failure: (state) => Center(
                  child: Text(state.message ?? 'Error occured'),
                ),
                success: (state) => ListView.builder(
                  itemCount: state.list.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Text(state.list[index].id.toString()),
                    title: Text(state.list[index].name),
                    trailing: SizedBox(
                      width: 100,
                      child: CrudWidget(
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => context
                                    .read<EditGenreBloc>()
                                    .add(EditGenreEvent.delete(
                                        id: state.list[index].id)),
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            IconButton(
                                onPressed: () => showUpdateGenreModal(
                                    context, state.list[index]),
                                icon: const Icon(Icons.change_circle,
                                    color: Colors.blue))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<GenreListBloc, GenreListState>(
          builder: (context, state) {
            return CrudWidget(
                child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create'),
              onPressed: () =>
                  () => showCreateGenreModal(context, context.read()),
            ));
          },
        ),
      ),
    );
  }
}
