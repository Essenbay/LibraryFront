// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/feat/home/logic/authors/author_bloc.dart';
import 'package:libraryfront/feat/home/widgets/back_app_bar.dart';
import 'package:libraryfront/feat/home/widgets/crud_widget.dart';
import 'package:libraryfront/feat/profile/pages/author_list/author_edit_modal/update_author_modal.dart';
import 'package:libraryfront/feat/profile/pages/author_list/logic/author_list_bloc.dart';
import 'package:libraryfront/feat/profile/pages/author_list/author_edit_modal/create_author_modal.dart';
import 'package:libraryfront/feat/profile/pages/author_list/widgets/author_bloc_wrapper.dart';

class AuthorListScreen extends StatelessWidget {
  const AuthorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthorBlocWrapper(
      child: Scaffold(
        appBar: const BackIconLeadingAppBar(),
        body: BlocListener<AuthorEditBloc, AuthorState>(
          listener: (context, state) {
            state.mapOrNull(
              success: (value) => context
                  .read<AuthorListBloc>()
                  .add(const AuthorListEvent.fetch()),
            );
          },
          child: BlocBuilder<AuthorListBloc, AuthorListState>(
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
                      final result = await context.router.push(
                          TextbookItemScreenRoute(id: state.list[index].id));
                      if (result == true) {
                        context
                            .read<AuthorListBloc>()
                            .add(const AuthorListEvent.fetch());
                      }
                    },
                    child: ListTile(
                      leading: Text(state.list[index].id.toString()),
                      title: Text(
                          '${state.list[index].name} ${state.list[index].surname}'),
                      trailing: SizedBox(
                        width: 100,
                        child: CrudWidget(
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => context
                                      .read<AuthorEditBloc>()
                                      .add(AuthorEvent.delete(
                                          id: state.list[index].id)),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                              IconButton(
                                  onPressed: () => showUpdateAuthorModal(
                                      context, state.list[index]),
                                  icon: const Icon(Icons.change_circle,
                                      color: Colors.blue))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<AuthorListBloc, AuthorListState>(
          builder: (context, state) {
            return CrudWidget(
                child: ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create'),
              onPressed: () => () => showCreateAuthorModal(context),
            ));
          },
        ),
      ),
    );
  }
}
