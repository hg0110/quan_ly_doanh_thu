import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/pages/signin/signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0x665ac18e),
            Color(0x995ac18e),
            Color(0xcc5ac18e),
            Color(0xff5ac18e),
          ])),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: const Image(
                    image: AssetImage('assets/anh1.png'),
                    height: 200,
                  )),
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Welcome Back',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Loginscreen()));
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.push(
              //     //   context,
              //     //   MaterialPageRoute<MyUser>(
              //     //     builder: (BuildContext context) => MultiBlocProvider(
              //     //       providers: [
              //     //         // BlocProvider<SignUpBloc>(
              //     //         //     create: (context) => SignUpBloc(FirebaseUserRepo())),
              //     //         BlocProvider(
              //     //           create: (context) => SignUpBloc(FirebaseUserRepo())
              //     //             ..add(GetUser()),
              //     //         ),
              //     //         // BlocProvider(
              //     //         //   create: (context) => DeleteCustomerBloc(
              //     //         //       transactionRepository: FirebaseTransactionRepo()),
              //     //         // ),
              //     //       ],
              //     //       child: const Signupscreen(),
              //     //     ),
              //     //   ),
              //     // );
              //     // Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //         builder: (context) => const Signupscreen()));
              //   },
              //   child: Container(
              //     height: 53,
              //     width: 320,
              //     decoration: BoxDecoration(
              //         border: Border.all(color: Colors.white),
              //         borderRadius: BorderRadius.circular(30)),
              //     child: const Center(
              //       child: Text(
              //         'Sign Up',
              //         style: TextStyle(
              //           fontSize: 20,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const Spacer(),
              const Text(
                'Login with Social Media',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        )

        // @override
        // void initState() {
        //   tabController = TabController(initialIndex: 0, length: 2, vsync: this);
        //   super.initState();
        // }

        // SingleChildScrollView(
        //   child: SizedBox(
        //     height: MediaQuery.of(context).size.height,
        //     child: Stack(
        //       children: [
        //         Align(
        //           alignment: const AlignmentDirectional(20, -1.2),
        //           child: Container(
        //             height: MediaQuery.of(context).size.width,
        //             width: MediaQuery.of(context).size.width,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: Theme.of(context).colorScheme.tertiary),
        //           ),
        //         ),
        //         Align(
        //           alignment: const AlignmentDirectional(-2.7, -1.2),
        //           child: Container(
        //             height: MediaQuery.of(context).size.width / 1.3,
        //             width: MediaQuery.of(context).size.width / 1.3,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: Theme.of(context).colorScheme.secondary),
        //           ),
        //         ),
        //         Align(
        //           alignment: const AlignmentDirectional(2.7, -1.2),
        //           child: Container(
        //             height: MediaQuery.of(context).size.width / 1.3,
        //             width: MediaQuery.of(context).size.width / 1.3,
        //             decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: Theme.of(context).colorScheme.error),
        //           ),
        //         ),
        //         BackdropFilter(
        //           filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
        //           child: Container(),
        //         ),
        //         Align(
        //           alignment: Alignment.bottomCenter,
        //           child: SizedBox(
        //             height: MediaQuery.of(context).size.height / 1.8,
        //             child: Column(
        //               children: [
        //                 Padding(
        //                   padding: const EdgeInsets.symmetric(horizontal: 50.0),
        //                   child: TabBar(
        //                     controller: tabController,
        //                     unselectedLabelColor: Theme.of(context)
        //                         .colorScheme
        //                         .onBackground
        //                         .withOpacity(0.5),
        //                     labelColor:
        //                         Theme.of(context).colorScheme.onBackground,
        //                     tabs: const [
        //                       Padding(
        //                         padding: EdgeInsets.all(12.0),
        //                         child: Text(
        //                           'Sign In',
        //                           style: TextStyle(
        //                             fontSize: 18,
        //                           ),
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: EdgeInsets.all(12.0),
        //                         child: Text(
        //                           'Sign Up',
        //                           style: TextStyle(
        //                             fontSize: 18,
        //                           ),
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //                 Expanded(
        //                     child: TabBarView(
        //                   controller: tabController,
        //                   children: [
        //                     BlocProvider<SignInBloc>(
        //                       create: (context) => SignInBloc(
        //                           userRepository: context
        //                               .read<AuthenticationBloc>()
        //                               .userRepository),
        //                       child: const SignInScreen(),
        //                     ),
        //                     BlocProvider<SignUpBloc>(
        //                       create: (context) => SignUpBloc(
        //                           userRepository: context
        //                               .read<AuthenticationBloc>()
        //                               .userRepository),
        //                       child: const SignUpScreen(),
        //                     ),
        //                   ],
        //                 ))
        //               ],
        //             ),
        //           ),
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
