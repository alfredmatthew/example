import 'package:example/main.dart';
import 'package:example/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/bloc/form_submission_state.dart';
import 'package:example/bloc/login_event.dart';
import 'package:example/bloc/login_state.dart';
import 'package:example/bloc/login_bloc.dart';
import 'package:example/repository/login_repository.dart';
import 'package:example/repository/register_repository.dart';
import 'package:example/view/register_page.dart';
import 'package:example/database/sql_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  final Map? data;

  const LoginView({super.key, this.data});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

  void refresh() async {
    final data = await SQLHelper.getUser();
    setState(() {
      users = data;
    });
  }

  @override
  void initState(){
    refresh();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Success'),
              ),
            );
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HomeView(),
              ),
            ).then((_) => refresh());
          }
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state.formSubmissionState as SubmissionFailed)
                    .exception
                    .toString()),
              ),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                  body: Form(
            key: formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Username',
                    ),
                    validator: (value) =>
                        value == '' ? 'Please enter your Username' : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<LoginBloc>().add(
                                isPasswordVisibleChanged(),
                              );
                        },
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: state.isPasswordVisible
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                    obscureText: !state.isPasswordVisible,
                    validator: (value) =>
                        value == '' ? 'Please enter your Password' : null,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(
                                FormSubmitted(
                                    username: usernameController.text,
                                    password: passwordController.text),
                              );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: state.formSubmissionState is FormSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("Login"),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () {
                          Map<String, dynamic> formData = {};
                          formData['username'] = usernameController.text;
                          formData['password'] = passwordController.text;
                          pushRegister(context);
                        },
                        child: const Text('Belum punya akun?'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )));
        }),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }
}
