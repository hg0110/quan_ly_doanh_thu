import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';

Future<void> UpdateDriverScreen(BuildContext context, Driver driver) async {
  final TextEditingController textNameController =
      TextEditingController(text: driver.name);
  final TextEditingController textAddressController =
      TextEditingController(text: driver.address);
  final TextEditingController textPhoneController =
      TextEditingController(text: driver.phone);
  final TextEditingController textNoteController =
      TextEditingController(text: driver.note);

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cập nhật thông tin Lái xe'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: textNameController,
                decoration: const InputDecoration(hintText: "Name"),
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
                decoration: const InputDecoration(hintText: "Note"),
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
                final newDriverName = textNameController.text;
                final newDriverAddress = textAddressController.text;
                final newDriverPhone = textPhoneController.text;
                if (newDriverName.isEmpty ||
                    newDriverAddress.isEmpty ||
                    newDriverPhone.isEmpty) {
                  // Show an error message (e.g., usinga SnackBar or Dialog)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng điền đầy đủ thông tin!')),
                  );
                } else {
                  final driverRepo = FirebaseDriverRepo();

                  if (newDriverName != driver.name) {
                    final existingDriver =
                        await driverRepo.getDriverByName(newDriverName);
                    if (existingDriver != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Đã có lái xe có tên này!')),
                      );
                      return;
                    }
                  } else {
                    // Update the driver object
                    driver.name = newDriverName;
                    driver.address = newDriverAddress;
                    driver.phone = newDriverPhone;
                    driver.note = textNoteController.text;
                    driver.date = DateTime.now();

                    // Update driver in Firebase
                    await driverRepo.updateDriver(driver);

                    Navigator.of(context).pop(); // Close the dialog
                  }
                }
              }),
        ],
      );
    },
  );
}
