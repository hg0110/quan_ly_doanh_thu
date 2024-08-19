import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';

import '../../app.dart';

class ProfilePage extends StatefulWidget {
  final MyUser user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late MyUser user;
  late TextEditingController textNameController = TextEditingController();
  late TextEditingController textEmailController = TextEditingController();
  late TextEditingController textRoleController = TextEditingController();

  // final TextEditingController textNoteController =
  // TextEditingController(text: user.);
  @override
  void initState() {
    user = widget.user; // Initialize user from constructor
    textNameController = TextEditingController(text: widget.user.name);
    textEmailController = TextEditingController(text: widget.user.email);
    textRoleController = TextEditingController(text: widget.user.roles);
    super.initState();
  }

  //
  // @override
  // void dispose() {
  //   //Dispose controllers to prevent memory leaks
  //   textNameController.dispose();
  //   textEmailController.dispose();
  //   textRoleController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color(0xff5ac18e),
              Color(0xcc5ac18e),
              Color(0x995ac18e),
              Color(0x665ac18e),
            ])),
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 20),
              child: Text(
                'Xin Chào!',
                style: GoogleFonts.eduVicWaNtBeginner(
                    fontSize: 27,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                    top: 70, left: 15, right: 15, bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    TextField(
                      controller: textNameController,
                      decoration: const InputDecoration(hintText: "Họ tên"),
                    ),
                    // TextField(
                    //   controller: textEmailController,
                    //   decoration: const InputDecoration(hintText: "Email"),
                    // ),
                    // TextField(
                    //   controller: textRoleController,
                    //   decoration: const InputDecoration(hintText: "Quyền"),
                    // ),
                    const SizedBox(height: 15),
                    Text('Email: ${widget.user.email}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    Text('Quyền: ${widget.user.roles}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    // TextField(
                    //   controller: textNoteController,
                    //   decoration: const InputDecoration(hintText: "Note"),
                    // ),

                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async{
                          // Update user data
                          final newUserName = textNameController.text;
                          if (newUserName.isEmpty ) {
                            // Show an error message (e.g., usinga SnackBar or Dialog)
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Vui lòng điền đầy đủ thông tin!')),
                            );
                          } else {
                            user.name = newUserName;
                            // user.roles = selectedRole!;
                            user.date = DateTime.now();

                            // Update driver in Firebase
                            await userRepository.updateUser(user);
                            Navigator.of(context).pop(); // Close the dialog
                          }
                          // You would typically call a function here to update the user data in your repository (e.g., database or API)
                          // Example: userRepository.updateUser(user);
                          await ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Đã cập nhật thông tin!')),
                          );
                        },
                        child: const Text('Lưu'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
