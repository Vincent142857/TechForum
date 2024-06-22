import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/features/auth/domain/entities/user_entity.dart';
import 'package:flutterapp/features/auth/presentation/views/register_screen.dart';
import 'package:flutterapp/features/auth/presentation/views/welcome_screen.dart';
import 'package:formz/formz.dart';

import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isFocusedEmail = false;
  bool _isFocusedPassword = false;

  // late MyFormState _state;
  // void _onEmailChanged() {
  //   setState(() {
  //     _state = _state.copyWith(email: Email.dirty(emailController.text));
  //   });
  // }
  //
  // void _onPasswordChanged() {
  //   setState(() {
  //     _state =
  //         _state.copyWith(password: Password.dirty(passwordController.text));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/login_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Login form
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Sign in',
                      //style: Theme.of(context).textTheme.headlineSmall,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Don\'t have an account? Register here',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Color.fromARGB(255, 226, 98, 88)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        filled: true,
                        fillColor: _isFocusedEmail
                            ? const Color.fromARGB(143, 55, 108, 148)
                            : const Color.fromARGB(93, 55, 108, 148),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isFocusedEmail = true;
                          _isFocusedPassword = false;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          _isFocusedEmail = false;
                        });
                      },
                    ),
                    const SizedBox(height: 18.0),
                    TextField(
                      obscureText: _hidePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        filled: true,
                        fillColor: _isFocusedPassword
                            ? const Color.fromARGB(143, 55, 108, 148)
                            : const Color.fromARGB(93, 55, 108, 148),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(_hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isFocusedEmail = false;
                          _isFocusedPassword = true;
                        });
                      },
                      onEditingComplete: () {
                        setState(() {
                          _isFocusedPassword = false;
                        });
                      },
                    ),
                    const SizedBox(height: 18.0),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LoggedIn(
                            email: emailController.text,
                            password: passwordController.text));
                      },
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyFormState with FormzMixin {
  MyFormState({
    Email? email,
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
  }) : email = email ?? Email.pure();

  final Email email;
  final Password password;
  final FormzSubmissionStatus status;

  MyFormState copyWith({
    Email? email,
    Password? password,
    FormzSubmissionStatus? status,
  }) {
    return MyFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [email, password];
}