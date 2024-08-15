import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/blocs/get_shipping_order_bloc/get_shipping_order_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/shipping_order_screen.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/create_transaction_bloc/create_transaction_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/get_transaction_bloc/get_Transaction_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/transaction.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

import 'service/blocs/create_category_bloc/create_category_bloc.dart';
import 'service/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'car/blocs/get_car_bloc/get_car_bloc.dart';
import 'customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import 'driver/blocs/get_driver_bloc/get_driver_bloc.dart';

class CommonScreen extends StatelessWidget {
  const CommonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: const Text(""),
        ),
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
                'HÃY CHỌN ',
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
                        builder: (BuildContext context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                    create: (context) => GetShippingOrderBloc(
                                        FirebaseShippingOrderRepo())
                                      ..add(GetShippingOrder())),
                                BlocProvider(
                                  create: (context) =>
                                      GetDriverBloc(FirebaseDriverRepo())
                                        ..add(GetDriver()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      GetCustomerBloc(FirebaseTransactionRepo())
                                        ..add(GetCustomer()),
                                ),
                                BlocProvider(
                                  create: (context) =>
                                      GetCarBloc(FirebaseShippingOrderRepo())
                                        ..add(GetCar()),
                                ),
                              ],
                              child: const ShippingOrderScreen(),
                            )),
                  );
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                    child: Text(
                      'LỆNH VẬN CHUYỂN',
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
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
                            create: (context) => CreateTransactionBloc(
                                FirebaseTransactionRepo()),
                          ),
                          BlocProvider(
                              create: (context) => GetShippingOrderBloc(
                                  FirebaseShippingOrderRepo())
                                ..add(GetShippingOrder())),
                          BlocProvider(
                              create: (context) => GetTransactionBloc(
                                  FirebaseTransactionRepo())
                                ..add(GetTransaction())),
                        ],
                        child: const Transaction(),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 53,
                  width: 320,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                    child: Text(
                      'GIAO DỊCH',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              // const Text(
              //   'Login with Social Media',
              //   style: TextStyle(fontSize: 17, color: Colors.white),
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
            ],
          ),
        ));
  }
}
