import 'dart:math';

import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/common_screen.dart';
import 'package:quan_ly_doanh_thu/pages/customer/customer_screen.dart';
import 'package:quan_ly_doanh_thu/pages/service/blocs/delete_category_bloc/delete_category_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/shipping_order_screen.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/get_transaction_bloc/get_Transaction_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/transaction_screen.dart';
import 'package:quan_ly_doanh_thu/pages/user/blocs/get_user_bloc/get_user_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/user/user_screen.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../car/blocs/create_car_bloc/create_car_bloc.dart';
import '../service/blocs/create_category_bloc/create_category_bloc.dart';
import '../service/blocs/get_categories_bloc/get_categories_bloc.dart';
import '../car/blocs/delete_car_bloc/delete_car_bloc.dart';
import '../car/car_screen.dart';
import '../components/drawer.dart';
import '../customer/blocs/delete_customer_bloc/delete_customer_bloc.dart';
import '../customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import '../driver/blocs/delete_driver_bloc/delete_driver_bloc.dart';
import '../driver/blocs/get_driver_bloc/get_driver_bloc.dart';
import '../driver/driver_screen.dart';
import '../service/service_screen.dart';
import '../shipping_order/blocs/get_shipping_order_bloc/get_shipping_order_bloc.dart';
import '../signup/bloc/signup_bloc/signup_bloc.dart';
import '../stats/stats.dart';
import '../transaction/blocs/create_expense_bloc/create_expense_bloc.dart';
import '../transaction/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import '../user/blocs/delete_user_bloc/delete_user_bloc.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Colors.blue;
  Color unselectedItem = Colors.grey;

  void goToShippingOrderPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) =>
                          GetShippingOrderBloc(FirebaseShippingOrderRepo())
                            ..add(GetShippingOrder())),
                  BlocProvider(
                    create: (context) =>
                        GetDriverBloc(FirebaseDriverRepo())..add(GetDriver()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetCustomerBloc(FirebaseTransactionRepo())
                          ..add(GetCustomer()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetCarBloc(FirebaseShippingOrderRepo())..add(GetCar()),
                  ),
                ],
                child: const ShippingOrderScreen(),
              )),
    );
  }

  void goToPersonnelPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                      create: (context) =>
                          GetUserBloc(FirebaseUserRepo())..add(GetUser())),
                  BlocProvider<SignUpBloc>(
                      create: (context) =>
                          SignUpBloc(userRepository: FirebaseUserRepo())),
                  BlocProvider<DeleteUserBloc>(
                      create: (context) =>
                          DeleteUserBloc(userRepository: FirebaseUserRepo())),
                ],
                child: const UserScreen(),
              )),
    );
  }

  void goToTransactionPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<Expense>(
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  CreateCategoryBloc(FirebaseTransactionRepo()),
            ),
            BlocProvider(
              create: (context) => GetCategoriesBloc(FirebaseTransactionRepo())
                ..add(GetCategories()),
            ),
            BlocProvider(
              create: (context) => GetExpensesBloc(FirebaseTransactionRepo())
                ..add(GetExpenses()),
            ),
            BlocProvider(
              create: (context) => CreateExpenseBloc(FirebaseTransactionRepo()),
            ),
            BlocProvider(
              create: (context) => GetTransactionBloc(FirebaseTransactionRepo())
                ..add(GetTransaction()),
            ),
          ],
          child: const TransactionScreen(),
        ),
      ),
    );
  }

  void goToCustomerPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<Customer>(
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => GetCustomerBloc(FirebaseTransactionRepo())
                ..add(GetCustomer()),
            ),
            BlocProvider(
              create: (context) => DeleteCustomerBloc(
                  transactionRepository: FirebaseTransactionRepo()),
            ),
          ],
          child: const CustomerScreen(),
        ),
      ),
    );
  }

  void goToCarPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<Car>(
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  GetCarBloc(FirebaseShippingOrderRepo())..add(GetCar()),
            ),
            BlocProvider<CreateCarBloc>(
                create: (context) => CreateCarBloc(FirebaseShippingOrderRepo())),
            BlocProvider(
              create: (context) => DeleteCarBloc(
                  shippingOrderRepository: FirebaseShippingOrderRepo()),
            ),
          ],
          child: const CarScreen(),
        ),
      ),
    );
  }

  void goToDriverPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<Driver>(
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  GetDriverBloc(FirebaseDriverRepo())..add(GetDriver()),
            ),
            BlocProvider(
              create: (context) =>
                  DeleteDriverBloc(driverRepository: FirebaseDriverRepo()),
            ),
          ],
          child: const DriverScreen(),
        ),
      ),
    );
  }
  void goToCategoryPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute<Category>(
        builder: (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  GetCategoriesBloc(FirebaseTransactionRepo())..add(GetCategories()),
            ),
            BlocProvider(
              create: (context) =>
                  DeleteCategoryBloc(transactionRepository: FirebaseTransactionRepo()),
            ),
          ],
          child: const ServiceScreen(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetTransactionBloc, GetTransactionState>(
        builder: (context, state) {
      if (state is GetTransactionSuccess) {
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Doanh thu',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            ),
            drawer: MyDrawer(
              onShippingOrderTap: goToShippingOrderPage,
              onPersonnelTap: goToPersonnelPage,
              onTransactionTap: goToTransactionPage,
              onCustomerTap: goToCustomerPage,
              onCarTap: goToCarPage,
              onDriverTap: goToDriverPage,
              onCategoryTap: goToCategoryPage,
              // onSingOut: signOut,
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: BottomNavigationBar(
                  onTap: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  elevation: 3,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.home,
                            color: index == 0 ? selectedItem : unselectedItem),
                        label: 'Home'),
                    BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.graph_square_fill,
                            color: index == 1 ? selectedItem : unselectedItem),
                        label: 'Stats')
                  ]),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute<void>(
                //       builder: (BuildContext context) => const AddExpense(),
                //     ));
                Transactions? newTransaction = await Navigator.push(
                  context,
                  MaterialPageRoute<Transactions>(
                    builder: (BuildContext context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              CreateCategoryBloc(FirebaseTransactionRepo()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetCategoriesBloc(FirebaseTransactionRepo())
                                ..add(GetCategories()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CreateExpenseBloc(FirebaseTransactionRepo()),
                        ),
                      ],
                      child: const CommonScreen(),
                    ),
                  ),
                );

                if (newTransaction != null) {
                  setState(() {
                    state.transaction.insert(0, newTransaction);
                  });
                }
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.primary,
                      ],
                      transform: const GradientRotation(pi / 4),
                    )),
                child: const Icon(CupertinoIcons.add),
              ),
            ),
            body: index == 0
                ? MainScreen(state.transaction)
                : const StatScreen(
                    title: 'Thống kê',
                  ));
      } else {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
    });
  }
}
