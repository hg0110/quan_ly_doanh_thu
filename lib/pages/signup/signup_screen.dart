import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

import '../components/my_text_field.dart';
import 'bloc/signup_bloc/signup_bloc.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}
//
// final List<String> roleItems = [
//   'admin',
//   'user',
// ];

class _SignupscreenState extends State<Signupscreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xff5ac18e),
              Color(0xcc5ac18e),
              Color(0x995ac18e),
              Color(0x665ac18e),
            ])),
            child: const Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: Text(
                'Hello \nSign Up!',
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 70),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyTextField(
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: const Icon(CupertinoIcons.mail_solid),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            } else if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                .hasMatch(val)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: const Icon(CupertinoIcons.lock_fill),
                          onChanged: (val) {
                            if (val!.contains(RegExp(r'[A-Z]'))) {
                              setState(() {
                                containsUpperCase = true;
                              });
                            } else {
                              setState(() {
                                containsUpperCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[a-z]'))) {
                              setState(() {
                                containsLowerCase = true;
                              });
                            } else {
                              setState(() {
                                containsLowerCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[0-9]'))) {
                              setState(() {
                                containsNumber = true;
                              });
                            } else {
                              setState(() {
                                containsNumber = false;
                              });
                            }
                            if (val.contains(RegExp(
                                r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                              setState(() {
                                containsSpecialChar = true;
                              });
                            } else {
                              setState(() {
                                containsSpecialChar = false;
                              });
                            }
                            if (val.length >= 8) {
                              setState(() {
                                contains8Length = true;
                              });
                            } else {
                              setState(() {
                                contains8Length = false;
                              });
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                                if (obscurePassword) {
                                  iconPassword = CupertinoIcons.eye_fill;
                                } else {
                                  iconPassword = CupertinoIcons.eye_slash_fill;
                                }
                              });
                            },
                            icon: Icon(iconPassword),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            } else if (!RegExp(
                                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                .hasMatch(val)) {
                              return 'Please enter a valid password';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "⚈  1 uppercase",
                              style: TextStyle(
                                  color: containsUpperCase
                                      ? Colors.green
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                            Text(
                              "⚈  1 lowercase",
                              style: TextStyle(
                                  color: containsLowerCase
                                      ? Colors.green
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                            Text(
                              "⚈  1 number",
                              style: TextStyle(
                                  color: containsNumber
                                      ? Colors.green
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "⚈  1 special character",
                              style: TextStyle(
                                  color: containsSpecialChar
                                      ? Colors.green
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                            Text(
                              "⚈  8 minimum character",
                              style: TextStyle(
                                  color: contains8Length
                                      ? Colors.green
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: MyTextField(
                          controller: nameController,
                          hintText: 'Name',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                          prefixIcon: const Icon(CupertinoIcons.person_fill),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill in this field';
                            } else if (val.length > 30) {
                              return 'Name too long';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: DropdownButton(
                        hint: selectedRole == null
                            ? const Text('Chọn quyền')
                            : Text(
                                selectedRole!,
                                style: const TextStyle(color: Colors.green),
                              ),
                        isExpanded: true,
                        iconSize: 35.0,
                        style: const TextStyle(color: Colors.blue),
                        items: ['admin', 'user'].map(
                          (val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                            () {
                              selectedRole = val;
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    !signUpRequired
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextButton(
                                onPressed: () {
                                  // if (_formKey.currentState!.validate()) {
                                  MyUser myUser = MyUser.empty;
                                   // myUser = myUser.copyWith(
                                   //    userId: const Uuid().v1(),
                                   //    email: emailController.text,
                                   //    name: nameController.text,
                                   //    roles: selectedRole!,
                                   //    date: DateTime.now());
                                  myUser = myUser.copyWith(
                                    email: emailController.text,
                                    name: nameController.text,
                                    roles: selectedRole,
                                    date: DateTime.now()
                                  );
                                  setState(() {
                                    context.read<SignUpBloc>().add(
                                        SignUpRequired(
                                            myUser, passwordController.text));
                                  });
                                  Navigator.of(context).pop();
                                  // }
                                },
                                style: TextButton.styleFrom(
                                    elevation: 3.0,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60))),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          )
                        : const CircularProgressIndicator()
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
