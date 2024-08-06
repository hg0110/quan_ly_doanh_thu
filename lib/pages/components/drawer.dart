import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/pages/components/my_list_tile.dart';

import '../signin/bloc/signin_bloc/signin_bloc.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onShippingOrderTap;
  final void Function()? onPersonnelTap;
  final void Function()? onTransactionTap;
  final void Function()? onCustomerTap;
  final void Function()? onCarTap;
  final void Function()? onDriverTap;

  const MyDrawer(
      {super.key,
      this.onShippingOrderTap,
      this.onTransactionTap,
      this.onCustomerTap,
      this.onCarTap, this.onDriverTap, this.onPersonnelTap});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  late SignInBloc _bloc;

  @override
  void initState() {
    _bloc = SignInBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const DrawerHeader(
              // decoration: BoxDecoration(
              //   color: Colors.grey,
              // ),
              child: Icon(
            Icons.person,
            // color: Colors.black,
            size: 64,
          )),
          MyListTile(
            icon: Icons.home,
            text: 'TRANG CHỦ',
            onTap: () => Navigator.pop(context),
          ),
          MyListTile(
            icon: Icons.person,
            text: 'LỆNH VẬN CHUYỂN',
            onTap: widget.onShippingOrderTap,
          ),
          MyListTile(
            icon: Icons.person,
            text: 'NHÂN VIÊN',
            onTap: widget.onPersonnelTap,
          ),
          MyListTile(
            icon: Icons.payment,
            text: 'GIAO DỊCH',
            onTap: widget.onTransactionTap,
          ),
          MyListTile(
            icon: Icons.person_add,
            text: 'KHÁCH HÀNG',
            onTap: widget.onCustomerTap,
          ),
          MyListTile(
            icon: Icons.car_crash,
            text: 'XE',
            onTap: widget.onCarTap,
          ),
          MyListTile(
            icon: Icons.drive_eta,
            text: 'LÁI XE',
            onTap: widget.onDriverTap,
          ),
          const SizedBox(height: 100.0),
          ElevatedButton(
            onPressed: () {
              _bloc.add(const SignOutRequired());
            },
            // icon: const Icon(Icons.login)
            child: const Text("ĐĂNG XUẤT"),
          ),
        ],
      ),
    );
  }
}
