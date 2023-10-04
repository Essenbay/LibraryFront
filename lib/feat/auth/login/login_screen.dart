import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libraryfront/core/navigation/auto_route.gr.dart';
import 'package:libraryfront/core/services/auth_status/app_cubit.dart';
import 'package:libraryfront/core/util/ui.dart';
import 'package:libraryfront/feat/auth/logic/login_bloc.dart';
import 'package:libraryfront/feat/auth/login/login_bloc_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginBlocWrapper(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () =>
                    context.router.replace(const RegisterScreenRoute()),
                child: const Text('Register'))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Login',
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
                controller: _password,
                placeholder: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 10),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return state.maybeMap(
                    failure: (value) => ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      leading: const Icon(Icons.error),
                      title: Text(value.message ?? 'Error occured'),
                    ),
                    orElse: () => const SizedBox(),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                  state.mapOrNull(
                    success: (state) {
                      context
                          .read<AppStateCubit>()
                          .setAuth(state.token, state.role);
                      return context.router.pushAndPopUntil(
                          const MainScreenRoute(),
                          predicate: ModalRoute.withName('/'));
                    },
                  );
                },
                builder: (context, state) => ElevatedButton(
                  onPressed: () {
                    if (_email.text.isEmpty || _password.text.isEmpty) {
                      showSnackBar(context, 'Fields must not be empty');
                    } else {
                      context.read<LoginBloc>().add(LoginEvent.login(
                          email: _email.text, password: _password.text));
                    }
                  },
                  child: const Text('Login'),
                ),
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
