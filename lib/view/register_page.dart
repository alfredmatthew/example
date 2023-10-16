import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:example/bloc/form_submission_state.dart';
import 'package:example/bloc/login_event.dart';
import 'package:example/bloc/login_state.dart';
import 'package:example/bloc/login_bloc.dart';
import 'package:example/repository/login_repository.dart';
import 'package:example/repository/register_repository.dart';
import 'package:example/view/login_page.dart';
import 'package:example/database/sql_helper.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  bool value = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController usiaController = TextEditingController();

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
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state.formSubmissionState as SubmissionFailed)
                    .exception
                    .toString()),
              ),
            );
          }
          if (state.formSubmissionState is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Register Success'),
              ),
            );
            Map<String, dynamic> formData = {};
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => LoginView(data: formData),
              ),
            ).then((_) => refresh());
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Username',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Username';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Email';
                          }
                          if (!value.contains('@')) {
                            return 'Email harus menggunakan @';
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Password';
                          }
                          if (value.length < 5) {
                            return 'Password mminimal 5 digit';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: notelpController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone_android),
                          labelText: 'Nomor Telepon',
                        ),
                        //hanya bisa menerima angka
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Nomor Telepon';
                          }
                          if (value.length < 10) {
                            return 'Nomor Telepon minimal 10 angka';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: dateController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          labelText: "Tanggal Lahir",
                          prefixIcon: Icon(Icons.calendar_today),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal Tidak Boleh Kosong';
                          }
                          return null;
                        },
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2024),
                          );

                          if (pickedDate != null) {
                            print(pickedDate);
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(formattedDate);

                            setState(() {
                              dateController.text = formattedDate;
                            });
                          }
                        },
                      ),
                      TextFormField(
                        controller: usiaController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.create),
                          labelText: 'Usia',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan Usia';
                          }
                          if (value == '0') {
                            return 'Usia tidak boleh nol';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginBloc>().add(
                                    FormRegisterSubmitted(
                                      name: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      telepon: notelpController.text,
                                      tanggalLahir: dateController.text,
                                      usia: usiaController.text,
                                    ),
                                  );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 16.0),
                            child: state.formSubmissionState is FormSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Register"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
