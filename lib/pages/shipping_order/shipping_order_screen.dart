import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../car/blocs/get_car_bloc/get_car_bloc.dart';
import '../customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import '../driver/blocs/get_driver_bloc/get_driver_bloc.dart';
import 'add_shipping_order.dart';
import 'blocs/create_shipping_order_bloc/create_shipping_order_bloc.dart';
import 'blocs/get_shipping_order_bloc/get_shipping_order_bloc.dart';

class ShippingOrderScreen extends StatefulWidget {
  const ShippingOrderScreen({super.key});

  // final VoidCallback onRefresh;
  @override
  State<ShippingOrderScreen> createState() => _ShippingOrderScreenState();
}

class _ShippingOrderScreenState extends State<ShippingOrderScreen> {
  ShippingOrder shippingOrder = ShippingOrder.empty;

  // String? selectedDriverId;
  bool isLoading = false;

  @override
  void initState() {
    shippingOrder = ShippingOrder.empty;
    super.initState();
    // selectedDriverId = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateShippingOrderBloc, CreateShippingOrderState>(
        listener: (context, state) {
          if (state is CreateShippingOrderSuccess) {
            Navigator.pop(context, shippingOrder);
          } else if (state is CreateShippingOrderLoading) {
            setState(() {
              isLoading = true;
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Text(
              "LỆNH VẬN CHUYỂN",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: BlocBuilder<GetShippingOrderBloc, GetShippingOrderState>(
            builder: (context, state) {
              if (state is GetShippingOrderLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetShippingOrderSuccess) {
                state.shippingOrder
                    .sort((a, b) => b.start_day.compareTo(a.start_day));
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.shippingOrder.length,
                  itemBuilder: (context, index) {
                    final shippingOrder = state.shippingOrder[index];
                    return Card(
                      surfaceTintColor: Colors.green,
                      shadowColor: Colors.green,
                      child: ListTile(
                        title: Row(
                          children: [
                            const Text("Tên Lệnh: "),
                            Text(shippingOrder.name),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Khách hàng: "),
                                Text(shippingOrder.customer.name),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Lái xe: "),
                                Text(shippingOrder.driver.name),
                              ],
                            ),
                            Row(
                              children: [
                                const Text("Xe: "),
                                Text(shippingOrder.car.BKS),
                              ],
                            ),
                            Row(children: [
                              const Text("Ngày bắt đầu: "),
                              Text(
                                DateFormat('dd/MM/yy hh:mm')
                                    .format(shippingOrder.start_day),
                                style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.w400),
                              )
                            ]),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("Lỗi hiển thị"),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
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
                          child: const AddShippingOrder(
                            // onRefresh: () {
                            //   // Refresh data on ShippingOrderScreen
                            //   context
                            //       .read<GetShippingOrderBloc>()
                            //       .add(GetShippingOrder());
                            // },
                              // shippingOrderRepository: FirebaseShippingOrderRepo(),
                          ),
                        )),
              );
              // var newShoppingOder = await  const AddShippingOrder();
              // context.read<GetShippingOrderBloc>().add(GetShippingOrder());
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }
}
