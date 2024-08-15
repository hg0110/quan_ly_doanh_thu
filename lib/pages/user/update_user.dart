import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/app.dart';
import 'package:user_repository/user_repository.dart';

Future<void> UpdateUserScreen(BuildContext context, MyUser user) async {
  final TextEditingController textNameController =
      TextEditingController(text: user.name);
  // final TextEditingController textEmailController =
  //     TextEditingController(text: user.email);
  String? selectedRole;

  await showDialog(
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
                    selectedRole = val;
                  },
                ),
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
                final newUserName = textNameController.text;
                if (newUserName.isEmpty ||
                    selectedRole == null) {
                  // Show an error message (e.g., usinga SnackBar or Dialog)
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(
                        content: Text('Vui lòng điền đầy đủ thông tin!')),
                  );
                } else {
                  user.name = newUserName;
                  user.roles = selectedRole!;
                  user.date = DateTime.now();

                  // Update driver in Firebase
                  await userRepository.updateUser(user);
                  Navigator.of(context).pop(); // Close the dialog
                }
              }
              ),
        ],
      );
    },
  );
}
