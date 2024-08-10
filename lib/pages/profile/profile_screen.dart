import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';

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
    textNameController = TextEditingController(text: user.name);
    textEmailController = TextEditingController(text: user.email);
    textRoleController = TextEditingController(text: user.roles);
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
            child: const Padding(
              padding: EdgeInsets.only(top: 60, left: 20),
              child: Text(
                'Xin chào \n!',
                style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
                padding: const EdgeInsets.only(top: 70),
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                    ),
                    TextField(
                      controller: textNameController,
                      decoration: const InputDecoration(hintText: "Họ tên"),
                    ),
                    TextField(
                      controller: textEmailController,
                      decoration: const InputDecoration(hintText: "Email"),
                    ),
                    TextField(
                      controller: textRoleController,
                      decoration: const InputDecoration(hintText: "Quyền"),
                    ),
                    // TextField(
                    //   controller: textNoteController,
                    //   decoration: const InputDecoration(hintText: "Note"),
                    // ),

                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Update user data
                        setState(() {
                          user = user.copyWith(
                            name: textNameController.text,
                            email: textEmailController.text,
                            // roles: textPhoneController.text,
                          );
                        });
                        // You would typically call a function here to update the user data in your repository (e.g., database or API)
                        // Example: userRepository.updateUser(user);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile updated')),
                        );
                      },
                      child: const Text('Update'),
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
