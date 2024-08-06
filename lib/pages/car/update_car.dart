import 'package:flutter/material.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

// class UpdateDriverScreen extends StatefulWidget {
//   final Driver driver;
//
//   const UpdateDriverScreen({Key? key, required this.driver}) : super(key: key);
//
//   @override
//   State<UpdateDriverScreen> createState() => _UpdateDriverScreenState();
// }
//
// class _UpdateDriverScreenState extends State<UpdateDriverScreen> {
//   // ... form fields and state management for updating driver properties ...
//
//   void _updateDriver() async {
//     // ... gather updated driver data from form fields ...
//
//     // Call the updateDriver function in your repository
//     // var  driver = await DriverRepository.updateDriver(updatedDriver);
//
//     // Navigate back to the previous screen with the updated driverNavigator.pop(context, updatedDriver);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Update Driver'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Form(
//           child: TextField(
//             decoration: const InputDecoration(hintText: "name"),
//             // controller: driver.name,
//           ),
//         ),
//       ),
//
//       // ... form fields for driver properties ...
//       // ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _updateDriver,
//         child: const Icon(Icons.save),
//       ),
//     );
//     // );
//   }
// }
Future<void> UpdateCarScreen(BuildContext context, Car car) async {
  final TextEditingController textNameController =
      TextEditingController(text: car.name);
  final TextEditingController textBKSController =
      TextEditingController(text: car.BKS);
  final TextEditingController textNoteController =
      TextEditingController(text: car.note);

  return showDialog(
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
                  final carRepo = FirebaseShippingOrderRepo();

                  if (newCarBKS != car.BKS) {
                    final existingCarBKS = await carRepo.getCarByBKS(newCarBKS);
                    if (existingCarBKS != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Đã có xe có số hiệu này!')),
                      );
                      return;
                    }
                  } else {
                    // Update the car object
                    car.name = newCarName;
                    car.BKS = newCarBKS;
                    car.note = textNoteController.text;
                    car.date = DateTime.now();

                    // Update driver in Firebase
                    await carRepo.updateCar(car);
                    Navigator.of(context).pop(); // Close the dialog
                  }
                }
              }),
        ],
      );
    },
  );
}
