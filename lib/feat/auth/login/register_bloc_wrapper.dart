import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/di/injection_container.dart';
import 'package:libraryfront/feat/auth/logic/register_bloc.dart';

class RegisterBlocWrapper extends StatelessWidget {
  const RegisterBlocWrapper({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RegisterBloc>(),
      child: child,
    );
  }
}
