import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/core/services/auth_status/app_cubit.dart';
import 'package:libraryfront/core/util/ui.dart';
import 'package:libraryfront/feat/auth/logic/auth_models.dart';
import 'package:libraryfront/feat/auth/logic/register_bloc.dart';
import 'package:libraryfront/feat/auth/login/register_bloc_wrapper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassord = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterBlocWrapper(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () =>
                    context.router.replace(const LoginScreenRoute()),
                child: const Text('Register'))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Register',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _email,
                placeholder: 'Email',
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _username,
                placeholder: 'Username',
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _password,
                placeholder: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: _confirmPassord,
                placeholder: 'Confirt Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  return state.maybeMap(
                    failure: (state) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      leading: const Icon(Icons.error),
                      title: Text(state.message ?? 'Error occured'),
                    ),
                    orElse: () => const SizedBox(),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocConsumer<RegisterBloc, RegisterState>(
                listener: (context, state) {
                  state.mapOrNull(
                    success: (successState) {
                      context
                          .read<AppStateCubit>()
                          .setAuth(successState.token, successState.role);
                      return context.router.pushAndPopUntil(
                          const MainScreenRoute(),
                          predicate: ModalRoute.withName('/'));
                    },
                  );
                },
                builder: (context, state) => ElevatedButton(
                    onPressed: () {
                      if (_email.text.isEmpty ||
                          _username.text.isEmpty ||
                          _password.text.isEmpty ||
                          _confirmPassord.text.isEmpty) {
                        showSnackBar(context, 'Fields must not be empty');
                      } else {
                        context.read<RegisterBloc>().add(
                              RegisterEvent.register(RegisterRequestModel(
                                  _username.text,
                                  _email.text,
                                  _password.text,
                                  _confirmPassord.text)),
                            );
                      }
                    },
                    child: const Text('Register')),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () => context.router.pushAndPopUntil(
                      const MainScreenRoute(),
                      predicate: ModalRoute.withName('/')),
                  child: const Text('or login as guest'))
            ],
          ),
        ),
      ),
    );
  }
}
