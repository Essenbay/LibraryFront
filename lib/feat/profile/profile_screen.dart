import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/core/services/auth_status/app_cubit.dart';
import 'package:libraryfront/feat/profile/logic/profile_bloc.dart';
import 'package:libraryfront/feat/profile/widgets/menu_tile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateCubit>(
      builder: (context, provider, _) {
        return BlocProvider(
          create: (context) =>
              getIt<ProfileBloc>()..add(const ProfileEvent.fetch()),
          child: Scaffold(
            appBar: AppBar(
              actions: [
                if (provider.authState == AppState.authenticated)
                  TextButton(
                      onPressed: () {
                        //TODO: Call logout from server
                        context.read<AppStateCubit>().setUnauth();
                        context.router.pushAndPopUntil(const LoginScreenRoute(),
                            predicate: ModalRoute.withName('/'));
                      },
                      child: const Text('Logout'))
                else
                  TextButton(
                      onPressed: () {
                        context.router.pushAndPopUntil(const LoginScreenRoute(),
                            predicate: ModalRoute.withName('/'));
                      },
                      child: const Text('Login'))
              ],
            ),
            body: provider.authState == AppState.authenticated
                ? BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, profileState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Spacer(flex: 2),

                          Text(
                            'Hello, ${profileState.maybeMap(success: (successState) => successState.data.name, orElse: () => '')}',
                            textAlign: TextAlign.center,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: profileState.maybeMap(
                                success: (successState) =>
                                    Text('Email: ${successState.data.email}'),
                                failure: (value) =>
                                    Text(value.message ?? 'Error occured'),
                                orElse: () => const SizedBox()),
                          ),
                          const Spacer(flex: 1),
                          // MenuTile(
                          //     text: 'User list
                          //     onClick: () => context.router.push(const UserListScreenRoute())),
                          if (provider.isAdmin)
                            MenuTile(
                                text: 'Genres',
                                onClick: () => context.router
                                    .push(const GenreListScreenRoute())),
                          if (provider.isAdmin)
                            MenuTile(
                                text: 'Authors',
                                onClick: () => context.router
                                    .push(const AuthorListScreenRoute())),
                          const Spacer(flex: 5),
                        ],
                      );
                    },
                  )
                : const Center(
                    child: Text('Hello, guest'),
                  ),
          ),
        );
      },
    );
  }
}
