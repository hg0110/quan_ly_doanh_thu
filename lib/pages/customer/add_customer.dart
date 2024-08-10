import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

import 'blocs/create_customer_bloc/create_customer_bloc.dart';

Future getAddCustomer(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        final TextEditingController textNameController =
            TextEditingController();
        final TextEditingController textAddressController =
            TextEditingController();
        final TextEditingController textPhoneController =
            TextEditingController();
        final TextEditingController textNoteController =
            TextEditingController();
        return AlertDialog(
          title: const Text('Thêm khách hàng'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: textNameController,
                  decoration: const InputDecoration(hintText: "Họ tên"),
                ),
                TextField(
                  controller: textAddressController,
                  decoration: const InputDecoration(hintText: "Địa chỉ"),
                ),
                TextField(
                  controller: textPhoneController,
                  decoration: const InputDecoration(hintText: "Số điện thoại"),
                ),
                TextField(
                  controller: textNoteController,
                  decoration: const InputDecoration(hintText: "Ghi chú"),
                ),
              ],
            ),
          ),
          actions: [
            MaterialButton(
              color: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              child: const Text("Lưu"),
              onPressed: () async {
                final newCustomerName = textNameController.text;
                final newCustomerAddress = textAddressController.text;
                final newCustomerPhone = textPhoneController.text;
                if (newCustomerName.isEmpty ||
                    newCustomerAddress.isEmpty ||
                    newCustomerPhone.isEmpty) {
                  // Show an error message (e.g., usinga SnackBar or Dialog)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng điền đầy đủ thông tin!')),
                  );
                } else {
                  final transactionRepo = FirebaseTransactionRepo();

                  // Check if a customer with the same name exists
                  final existingCustomer =
                      await transactionRepo.getCustomerByName(newCustomerName);

                  if (existingCustomer != null) {
                    // Show an error message (e.g., using a SnackBar or Dialog)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Đã có khách hàng có tên này!')),
                    );
                  } else {
                    final newCustomer = Customer(
                        customerId: const Uuid().v1(),
                        name: newCustomerName,
                        address: newCustomerAddress,
                        phone: newCustomerPhone,
                        note: textNoteController.text,
                        date: DateTime.now());
                    context
                        .read<CreateCustomerBloc>()
                        .add(CreateCustomer(newCustomer));
                    textNameController.clear();
                    textAddressController.clear();
                    textPhoneController.clear();
                    textNoteController.clear();
                    Navigator.of(context).pop();
                  }
                }
              },
            )
          ],
        );
      });
}
