import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/welcome_screen.dart';
import 'package:user_repository/user_repository.dart';

import 'app_view.dart';
import 'blocs/authentication_bloc/authentication_bloc.dart';

late UserRepository userRepository;

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    userRepository = FirebaseUserRepo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add MaterialApp for Directionality
      home: RepositoryProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(userRepository: userRepository),
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.role == 'admin') {
              return const MyAppView();
            } else if(state.role == 'user') {
              return const MyAppView();
            }else{
              // return const MyAppView();
              return const WelcomeScreen();
            }
        }
        ),
      ),
    );
  }
}
