import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:uuid/uuid.dart';

import 'blocs/create_car_bloc/create_car_bloc.dart';

Future getAddCar(BuildContext parentContext) {
  final TextEditingController textNameController = TextEditingController();
  final TextEditingController textBKSController = TextEditingController();
  final TextEditingController textNoteController = TextEditingController();

  return showDialog(
    context: parentContext,
    builder: (context) {
      return AlertDialog(
        title: const Text('Thêm xe'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: textNameController,
                decoration: const InputDecoration(hintText: "Tên xe"),
              ),
              TextField(
                controller: textBKSController,
                decoration: const InputDecoration(hintText: "Số hiệu"),
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
              final newCarName = textNameController.text;
              final newCarBKS = textBKSController.text;
              if (newCarName.isEmpty || newCarBKS.isEmpty) {
                // Show an error message (e.g., usinga SnackBar or Dialog)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Vui lòng điền đầy đủ thông tin!')),
                );
              } else {
                final ShippingOrderRepo = FirebaseShippingOrderRepo();
                // Check if a car with the same name exists
                final existingCar =
                    await ShippingOrderRepo.getCarByBKS(newCarBKS);
                if (existingCar != null) {
                  // Show an error message (e.g., using a SnackBar or Dialog)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã có xe có số hiệu này!')),
                  );
                } else {
                  final newCar = Car(
                      carId: const Uuid().v1(),
                      name: textNameController.text,
                      BKS: newCarBKS,
                      note: textNoteController.text,
                      date: DateTime.now());
                  parentContext.read<CreateCarBloc>().add(CreateCar(newCar));
                  textNameController.clear();
                  textBKSController.clear();
                  textNoteController.clear();
                  Navigator.of(context).pop();
                }
              }
            },
          )
        ],
      );
    },
  );
}
