import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

Future<void> UpdateCategoryScreen(BuildContext context, Category category) async {
  final TextEditingController textNameController =
  TextEditingController(text: category.name);
  // final TextEditingController textAddressController =
  // TextEditingController(text: driver.address);
  // final TextEditingController textPhoneController =
  // TextEditingController(text: driver.phone);
  final TextEditingController textNoteController =
  TextEditingController(text: category.note);

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cập nhật thông tin dịch vụ'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: textNameController,
                decoration: const InputDecoration(hintText: "Họ Tên"),
              ),
              // TextField(
              //   controller: textAddressController,
              //   decoration: const InputDecoration(hintText: "Địa chỉ"),
              // ),
              // TextField(
              //   controller: textPhoneController,
              //   decoration: const InputDecoration(hintText: "Số điện thoại"),
              // ),
              TextField(
                controller: textNoteController,
                decoration: const InputDecoration(hintText: "Ghi chú"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Thoát'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          MaterialButton(
            color: Theme.of(context).colorScheme.secondary,
            textColor: Colors.white,
            child: const Text("Lưu"),
            onPressed: () async {
              final newCategoryName = textNameController.text;
              if (newCategoryName.isEmpty ) {
                // Show an error message (e.g., usinga SnackBar or Dialog)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Vui lòng điền đầy đủ thông tin!')),
                );
              }
              final categoryRepo = FirebaseTransactionRepo();

              if (newCategoryName != category.name) {
                final existingDriver =
                await categoryRepo.getCategoryByName(newCategoryName);
                if (existingDriver != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã có lái xe có tên này!')),
                  );
                  return;
                }
              }
              // Update the driver object
              category.name = newCategoryName;
              category.note = textNoteController.text;
              category.date = DateTime.now();

              // Update driver in Firebase
              await categoryRepo.updateCategory(category);
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}
