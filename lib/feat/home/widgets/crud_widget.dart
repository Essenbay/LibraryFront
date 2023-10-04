import 'package:flutter/material.dart';
import 'package:libraryfront/core/services/auth_status/app_cubit.dart';
import 'package:provider/provider.dart';

class CrudWidget extends StatelessWidget {
  const CrudWidget({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateCubit>(builder: (context, provider, _) {
      if (provider.authState == AppState.authenticated && provider.isAdmin) {
        return child;
      } else {
        return const SizedBox();
      }
    });
  }
}
