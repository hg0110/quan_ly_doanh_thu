import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/signin/forgot_pw.dart';

import '../components/my_text_field.dart';
import 'bloc/signin_bloc/signin_bloc.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  late SignInBloc _bloc;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;
  String? selectedRole;

  @override
  void initState() {
    _bloc = SignInBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      bloc: _bloc,
      listener: (context, state) async{
        if (state is SignInSuccess) {
             await ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Đăng nhập thành công!'))
            );
             Navigator.pop(context);
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
            await ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Email hoặc mật khẩu không hợp lệ!')),
            );
          setState(() {
            signInRequired = false;
            _errorMsg = 'Email hoặc mật khẩu không hợp lệ!';
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Scaffold(
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
                    'Xin chào \nĐăng nhập!',
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 50.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Email',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: MyTextField(
                                controller: emailController,
                                hintText: 'example@example.com',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon:
                                    const Icon(CupertinoIcons.mail_solid),
                                errorMsg: _errorMsg,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Vui lòng điền vào trường này!';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                      .hasMatch(val)) {
                                    return 'Vui lòng nhập email hợp lệ!';
                                  }
                                  return null;
                                })),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(left: 50.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Mật khẩu',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )),
                        ),
                        // const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: MyTextField(
                            controller: passwordController,
                            hintText: 'Mật khẩu',
                            obscureText: obscurePassword,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(CupertinoIcons.lock_fill),
                            errorMsg: _errorMsg,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Vui lòng điền vào trường này!';
                              } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                  .hasMatch(val)) {
                                return 'Vui lòng nhập mật khẩu hợp lệ!';
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
                                    iconPassword =
                                        CupertinoIcons.eye_slash_fill;
                                  }
                                });
                              },
                              icon: Icon(iconPassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()));
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 30.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Quên mật khẩu?',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        if (!signInRequired)
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextButton(
                                onPressed: () async{
                                  if (_formKey.currentState!.validate()) {
                                    // if (selectedRole != null) {
                                    _bloc.add(SignInRequired(
                                      emailController.text,
                                      passwordController.text,
                                    ));
                                  }
                                  // Navigator.pop(context);
                                  // await ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //       content: Text('Đăng nhập thành công!')),
                                  // );
                                },
                                style: TextButton.styleFrom(
                                    elevation: 3.0,
                                    backgroundColor:
                                        Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(60))),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: Text(
                                    'Đăng nhập',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                          )
                        else
                          const CircularProgressIndicator(),
                        const SizedBox(
                          height: 100,
                        ),
                        // const Padding(
                        //   padding: EdgeInsets.only(right: 20.0),
                        //   child: Align(
                        //     child: Column(
                        //       children: [
                        //         Text(
                        //           "Không có tài khoản?",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.grey),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // TextButton(
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const Signupscreen()));
                        //   },
                        //   child: const Padding(
                        //     padding: EdgeInsets.only(right: 20.0),
                        //     child: Align(
                        //       child: Column(
                        //         children: [
                        //           Text(
                        //             "Sign Up",
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
