import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/pages/signin/signin_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0x665ac18e),
            Color(0x995ac18e),
            Color(0xcc5ac18e),
            Color(0xff5ac18e),
          ])),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(30.0),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: const Image(
                    image: AssetImage('assets/anh1.png'),
                    height: 200,
                  )),
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Chào mừng trở lại!',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: kToolbarHeight,
                  child: TextButton(
                      onPressed: () {
                        // Create Category Object and POP
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Loginscreen()));
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(40))),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                            fontSize: 22, color: Colors.white),
                      )),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Spacer(),
              const Text(
                'nmhg.dev',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ));
  }
}
