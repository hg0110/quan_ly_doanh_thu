import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/shipping_order_detail.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/my_user_bloc/my_user_bloc.dart';
import '../car/blocs/get_car_bloc/get_car_bloc.dart';
import '../customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import '../driver/blocs/get_driver_bloc/get_driver_bloc.dart';
import '../user/blocs/get_user_bloc/get_user_bloc.dart';
import 'add_shipping_order.dart';
import 'blocs/create_shipping_order_bloc/create_shipping_order_bloc.dart';
import 'blocs/delete_shipping_order_bloc/delete_shipping_order_bloc.dart';
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
    return MultiBlocListener(
        listeners: [
          BlocListener<CreateShippingOrderBloc, CreateShippingOrderState>(
            listener: (context, state) {
              if (state is CreateShippingOrderSuccess) {
                context
                    .read<GetShippingOrderBloc>()
                    .add(GetShippingOrder());
              } else if (state is CreateShippingOrderLoading) {
                setState(() {
                  isLoading = true;
                });
              }
            },
          ),
          BlocListener<DeleteShippingOrderBloc, DeleteShippingOrderState>(
            listener: (context, state) {
              if (state is DeleteShippingOrderSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa lệnh vận chuyển thành công')),
                );
                context
                    .read<GetShippingOrderBloc>()
                    .add(GetShippingOrder()); // Refresh driver list
              } else if (state is DeleteShippingOrderFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không xóa được lệnh vận chuyển')),
                );
              }
              context.read<GetShippingOrderBloc>().add(GetShippingOrder());
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .secondary,
            title: const Text("LỆNH VẬN CHUYỂN",
                style: TextStyle(color: Colors.white)),
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
                    return Dismissible(
                      key: Key(shippingOrder.ShippingId),
                      confirmDismiss: (direction) async {
                        if (shippingOrder.status == 'đang hoạt động') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                Text('Không thể xóa lái xe đang hoạt động')),
                          );
                          return false; // Prevent dismissal
                        } else {
                          return await _showDeleteConfirmationDialog(
                              context, shippingOrder);
                        }
                      },
                      onDismissed: (direction) {
                        context
                            .read<DeleteShippingOrderBloc>()
                            .add(DeleteShippingOrder(shippingOrder.ShippingId));
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShippingOrderDetail(
                                      shippingOrder: shippingOrder,),
                              ));
                        },
                        child: Card(
                          surfaceTintColor: Colors.green,
                          shadowColor: Colors.green,
                          child: ListTile(
                            title: Row(
                              children: [
                                const Text("Tên Lệnh: ", style:
                                const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                                Flexible(
                                    child: Text(
                                        shippingOrder.name,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                        const TextStyle(fontSize: 16,
                                            fontWeight: FontWeight.bold)
                                    )),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row(
                                //   children: [
                                //     const Text("Khách hàng: "),
                                //     Flexible(
                                //         child: Text(shippingOrder.customer.name,
                                //             overflow: TextOverflow.ellipsis)),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     const Text("Lái xe: "),
                                //     Flexible(
                                //         child: Text(shippingOrder.driver.name,
                                //             overflow: TextOverflow.ellipsis)),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     const Text("Xe: "),
                                //     Flexible(
                                //         child: Text(shippingOrder.car.BKS,
                                //             overflow: TextOverflow.ellipsis)),
                                //   ],
                                // ),
                                Row(
                                  children: [
                                    const Text("Ghi chú: "),
                                    Flexible(
                                        child: Text(
                                          shippingOrder.note,
                                          textAlign: TextAlign.justify,
                                        )),
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
                                        Theme
                                            .of(context)
                                            .colorScheme
                                            .outline,
                                        fontWeight: FontWeight.w400),
                                  )
                                ]),
                                Row(children: [
                                  const Text("Ngày hoàn thành: "),
                                  Text(
                                    DateFormat('dd/MM/yy hh:mm')
                                        .format(shippingOrder.end_day),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color:
                                        Theme
                                            .of(context)
                                            .colorScheme
                                            .outline,
                                        fontWeight: FontWeight.w400),
                                  )
                                ]),
                                Row(
                                  children: [
                                    const Text("Trạng thái: "),
                                    Text(shippingOrder.status,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: shippingOrder.status ==
                                                'đang hoạt động'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                    builder: (BuildContext context) =>
                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) =>
                                GetShippingOrderBloc(
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
                            BlocProvider(
                              create: (context) =>
                              MyUserBloc(myUserRepository: FirebaseUserRepo())
                                ..add(GetMyUser(myUserId: '')),
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
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .secondary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));

  }
  Future<bool> _showDeleteConfirmationDialog(
      BuildContext parentContext, ShippingOrder shippingOrder) async {
    bool confirmDelete = false;
    await showDialog<void>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa Lệnh vận chuyển ${shippingOrder.name} không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                parentContext
                    .read<DeleteShippingOrderBloc>()
                    .add(DeleteShippingOrder(shippingOrder.ShippingId));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return confirmDelete;
  }
}
