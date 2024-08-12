import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/customer/add_customer.dart';
import 'package:quan_ly_doanh_thu/pages/customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/customer/update_customer.dart';
import 'package:transaction_repository/transaction_repository.dart';

import 'blocs/create_customer_bloc/create_customer_bloc.dart';
import 'blocs/delete_customer_bloc/delete_customer_bloc.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  late Customer customer;

  bool isLoading = false;

  @override
  void initState() {
    customer = Customer.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CreateCustomerBloc, CreateCustomerState>(
            listener: (context, state) {
              if (state is CreateCustomerSuccess) {
                Navigator.pop(context, customer);
              } else if (state is CreateCustomerLoading) {
                setState(() {
                  isLoading = true;
                });
              }
            },
          ),
          BlocListener<DeleteCustomerBloc, DeleteCustomerState>(
            listener: (context, state) {
              if (state is DeleteCustomerSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa khách hàng thành công')),
                );
                context
                    .read<GetCustomerBloc>()
                    .add(GetCustomer()); // Refresh driver list
              } else if (state is DeleteCustomerFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không xóa được khách hàng')),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Text(
              "Khách Hàng",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: BlocBuilder<GetCustomerBloc, GetCustomerState>(
            builder: (context, state) {
              if (state is GetCustomerLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is GetCustomerSuccess) {
                state.customer.sort((a, b) => b.date.compareTo(a.date));
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: state.customer.length,
                  itemBuilder: (context, index) {
                    final customer = state.customer[index];
                    return Dismissible(
                      key: Key(customer.customerId),
                      confirmDismiss: (direction) async {
                        // Use confirmDismiss
                        return await _showDeleteConfirmationDialog(
                            context, customer);
                      },
                      onDismissed: (direction) {
                        context
                            .read<DeleteCustomerBloc>()
                            .add(DeleteCustomer(customer.customerId));
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Card(
                        surfaceTintColor: Colors.green,
                        shadowColor: Colors.green,
                        child: ListTile(
                          title: Row(
                            children: [
                              const Text("Họ tên: "),
                              Text(customer.name),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text("Địa chỉ: "),
                                  Text(customer.address),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Số điện thoại: "),
                                  Text(customer.phone),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text("Ghi chú: "),
                                  Text(customer.note),
                                ],
                              ),
                              Text(
                                DateFormat('dd/MM/yy hh:mm')
                                    .format(customer.date),
                                style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                          trailing: Column(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: 30,
                                  child: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      await UpdateCustomerScreen(
                                          context, customer);
                                      context
                                          .read<GetCustomerBloc>()
                                          .add(GetCustomer());
                                    },
                                  ),
                                ),
                              ),
                            ],
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
              var newCustomer = await getAddCustomer(context);
              if (newCustomer != null) {
                context.read<GetCustomerBloc>().add(GetCustomer());
              }
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext parentContext, Customer customer) async {
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
                Text(
                    'Bạn có chắc chắn muốn xóa khách hàng ${customer.name} không?'),
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
                    .read<DeleteCustomerBloc>()
                    .add(DeleteCustomer(customer.customerId));
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
