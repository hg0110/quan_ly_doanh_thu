import 'package:flutter/material.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

Future<void> UpdateCarScreen(BuildContext context, Car car) async {
  final TextEditingController textNameController =
      TextEditingController(text: car.name);
  final TextEditingController textBKSController =
      TextEditingController(text: car.BKS);
  final TextEditingController textNoteController =
      TextEditingController(text: car.note);

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cập nhật thông tin xe'),
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
                final newCarName = textNameController.text;
                final newCarBKS = textBKSController.text;
                if (newCarName.isEmpty || newCarBKS.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng điền đầy đủ thông tin!')),
                  );
                }
                final carRepo = FirebaseShippingOrderRepo();

                if (newCarBKS != car.BKS) {
                  final existingCarBKS = await carRepo.getCarByBKS(newCarBKS);
                  if (existingCarBKS != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã có xe có số hiệu này!')),
                    );
                    return;
                  }
                }
                // Update the car object
                car.name = newCarName;
                car.BKS = newCarBKS;
                car.note = textNoteController.text;
                car.date = DateTime.now();

                // Update driver in Firebase
                await carRepo.updateCar(car);
                Navigator.of(context).pop(); // Close the dialog
              }),
        ],
      );
    },
  );
}
