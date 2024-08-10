import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/app.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';

Future<void> UpdateUserScreen(
    BuildContext context, MyUser user) async {
  final TextEditingController textNameController =
  TextEditingController(text: user.name);
  final TextEditingController textEmailController =
  TextEditingController(text: user.email);
  // final TextEditingController textPhoneController =
  // TextEditingController(text: user.roles);
  // final TextEditingController textNoteController =
  // TextEditingController(text: user.note);
  String? selectedRole;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Cập nhật thông tin nhân viên'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: textNameController,
                decoration: const InputDecoration(hintText: "Họ Tên"),
              ),
              // TextField(
              //   controller: textEmailController,
              //   decoration: const InputDecoration(hintText: "email"),
              // ),
              // TextField(
              //   controller: textPhoneController,
              //   decoration: const InputDecoration(hintText: "quyền"),
              // ),
              // TextField(
              //   controller: textNoteController,
              //   decoration: const InputDecoration(hintText: "Ghi chú"),
              // ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: DropdownButton(
                  hint: selectedRole == null
                      ? const Text('Chọn quyền')
                      : Text(
                    selectedRole!,
                    style: const TextStyle(color: Colors.green),
                  ),
                  isExpanded: true,
                  iconSize: 35.0,
                  style: const TextStyle(color: Colors.blue),
                  items: ['admin', 'user'].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    // setState(
                    //       () {
                        selectedRole = val;
                      // },
                    // );
                  },
                ),
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
                final newUserName = textNameController.text;
                final newUserEmail = textEmailController.text;
                // final newCustomerPhone = textPhoneController.text;
                if (newUserName.isEmpty ||
                    newUserEmail.isEmpty ) {
                  // Show an error message (e.g., usinga SnackBar or Dialog)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vui lòng điền đầy đủ thông tin!')),
                  );
                } else {
                  // final userRepo = FirebaseUserRepo();

                  // Check if a customer with the same name exists
                  // final existingUser =
                  // await userRepo.getUserByEmail(newUserEmail);

                  // if (existingUser != null) {
                  //   // Show an error message (e.g., using a SnackBar or Dialog)
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //         content: Text('Đã có khách hàng có tên này!')),
                  //   );
                  // } else {
                    // Update the driver object
                    user.name = newUserName;
                    // user.email = newUserEmail;
                    user.roles = selectedRole!;
                    user.date = DateTime.now();

                    // Update driver in Firebase
                    await userRepository.updateUser(user);
                    Navigator.of(context).pop(); // Close the dialog
                  }
                }
              // }
              ),
        ],
      );
    },
  );
}
