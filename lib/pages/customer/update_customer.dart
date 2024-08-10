import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

Future<void> UpdateCustomerScreen(
    BuildContext context, Customer customer) async {
  final TextEditingController textNameController =
      TextEditingController(text: customer.name);
  final TextEditingController textAddressController =
      TextEditingController(text: customer.address);
  final TextEditingController textPhoneController =
      TextEditingController(text: customer.phone);
  final TextEditingController textNoteController =
      TextEditingController(text: customer.note);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cập nhật thông tin khách hàng'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: textNameController,
                decoration: const InputDecoration(hintText: "Họ Tên"),
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
                    // Update the driver object
                    customer.name = newCustomerName;
                    customer.address = newCustomerAddress;
                    customer.phone = newCustomerPhone;
                    customer.note = textNoteController.text;
                    customer.date = DateTime.now();

                    // Update driver in Firebase
                    await transactionRepo.updateCustomer(customer);
                    Navigator.of(context).pop(); // Close the dialog
                  }
                }
              }),
        ],
      );
    },
  );
}
