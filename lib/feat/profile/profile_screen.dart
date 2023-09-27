import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/feat/profile/widgets/menu_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Spacer(flex: 2),
          const Text('Hello, username'),
          const Spacer(flex: 1),
          MenuTile(
              text: 'User list',
              onClick: () => context.router.push(const UserListScreenRoute())),
          const Spacer(flex: 5),
        ],
      ),
    );
  }
}
