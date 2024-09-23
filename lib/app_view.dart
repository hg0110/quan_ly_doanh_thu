import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/create_car_bloc/create_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/delete_car_bloc/delete_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/customer/blocs/create_customer_bloc/create_customer_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/customer/blocs/delete_customer_bloc/delete_customer_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/driver/blocs/create_driver_bloc/create_driver_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/driver/blocs/delete_driver_bloc/delete_driver_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/driver/blocs/get_driver_bloc/get_driver_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/home/home_screen.dart';
import 'package:quan_ly_doanh_thu/pages/service/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/service/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/blocs/create_shipping_order_bloc/create_shipping_order_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/blocs/delete_shipping_order_bloc/delete_shipping_order_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/create_transaction_bloc/create_transaction_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/get_transaction_bloc/get_Transaction_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/user/blocs/delete_user_bloc/delete_user_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/user/blocs/get_user_bloc/get_user_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/welcome_screen.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';
import 'blocs/my_user_bloc/my_user_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                DeleteUserBloc(userRepository: FirebaseUserRepo()),
          ),
          //
          BlocProvider<CreateCustomerBloc>(
              create: (context) =>
                  CreateCustomerBloc(FirebaseTransactionRepo())),
          BlocProvider(
            create: (context) =>
            GetCustomerBloc(FirebaseTransactionRepo())
              ..add(GetCustomer()),
          ),
          BlocProvider(
            create: (context) =>
                DeleteCustomerBloc(
                    transactionRepository: FirebaseTransactionRepo()),
          ),

          //
          BlocProvider<CreateCarBloc>(
              create: (context) => CreateCarBloc(FirebaseShippingOrderRepo())),
          BlocProvider(
            create: (context) =>
                DeleteCarBloc(
                    shippingOrderRepository: FirebaseShippingOrderRepo()),
          ),
          BlocProvider(
            create: (context) =>
            GetCarBloc(FirebaseShippingOrderRepo())
              ..add(GetCar()),
          ),
          //
          BlocProvider<CreateDriverBloc>(
              create: (context) => CreateDriverBloc(FirebaseDriverRepo())),
          BlocProvider(
            create: (context) =>
            GetDriverBloc(FirebaseDriverRepo())
              ..add(GetDriver()),
          ),
          BlocProvider(
            create: (context) =>
                DeleteDriverBloc(driverRepository: FirebaseDriverRepo()),
          ),
          //
          BlocProvider<CreateShippingOrderBloc>(
              create: (context) =>
                  CreateShippingOrderBloc(FirebaseShippingOrderRepo())),
          BlocProvider(
              create: (context) =>
                  DeleteShippingOrderBloc(shippingOrderRepository: FirebaseShippingOrderRepo())
          ),
          BlocProvider(
            create: (context) =>
            GetUserBloc(FirebaseUserRepo())
              ..add(GetUser()),
          ),
          BlocProvider(
            create: (context) =>
                CreateCategoryBloc(FirebaseTransactionRepo()),
          ),
          BlocProvider(
            create: (context) =>
            GetCategoriesBloc(FirebaseTransactionRepo())
              ..add(GetCategories()),
          ),
        ],
        child: MaterialApp(
            title: 'Firebase Auth',
            theme: ThemeData(
              colorScheme: const ColorScheme.light(
                background: Colors.white,
                onBackground: Colors.black,
                primary: Color.fromRGBO(206, 147, 216, 1),
                onPrimary: Colors.black,
                secondary: Color.fromRGBO(69, 215, 111, 1.0),
                // secondary: Color.fromRGBO(244, 143, 177, 1),
                onSecondary: Colors.white,
                tertiary: Color.fromRGBO(255, 204, 128, 1),
                // tertiary: Color.fromRGBO(37, 255, 59, 1),
                error: Colors.red,
                outline: Color(0xFF424242),
              ),
            ),
            home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state.status == AuthenticationStatus.authenticated) {
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                          GetTransactionBloc(FirebaseTransactionRepo())
                            ..add(GetTransaction()),
                        ),
                        BlocProvider<CreateTransactionBloc>(
                            create: (context) => CreateTransactionBloc(
                                FirebaseTransactionRepo())),
                        BlocProvider(
                          create: (context) =>
                          MyUserBloc(
                              myUserRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository
                          )
                            ..add(GetMyUser(
                                myUserId: context
                                    .read<AuthenticationBloc>()
                                    .state
                                    .user!
                                    .uid
                            )),
                        ),
                      ],
                      child: const HomeScreen(),
                    );
                  } else {
                    return const WelcomeScreen();
                  }
                })));
  }
}
