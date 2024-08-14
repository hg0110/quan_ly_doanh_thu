import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/driver/blocs/create_driver_bloc/create_driver_bloc.dart';
import 'package:uuid/uuid.dart';

Future getAddDriver(BuildContext parentContext) {
  final TextEditingController textNameController = TextEditingController();
  final TextEditingController textAddressController = TextEditingController();
  final TextEditingController textPhoneController = TextEditingController();
  final TextEditingController textNoteController = TextEditingController();

  return showDialog(
    context: parentContext,
    builder: (context) {
      return AlertDialog(
        title: const Text('Thêm lái xe'),
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
                // Check if with the same name exists
                final existingDriver =
                    await driverRepo.getDriverByName(newDriverName);
                if (existingDriver != null) {
                  // Show an error message (e.g., using a SnackBar or Dialog)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã có lái xe có tên này!')),
                  );
                  return;
                }
                  final newDriver = Driver(
                      driverId: const Uuid().v1(),
                      name: newDriverName,
                      address: newDriverAddress,
                      phone: newDriverPhone,
                      note: textNoteController.text,
                      status:'chờ',
                      date: DateTime.now());
                  parentContext.read<CreateDriverBloc>().add(CreateDriver(newDriver));
                  textNameController.clear();
                  textAddressController.clear();
                  textPhoneController.clear();
                  textNoteController.clear();
                  Navigator.of(context).pop();
                }
              }
          )
        ],
      );
    },
  );
}
