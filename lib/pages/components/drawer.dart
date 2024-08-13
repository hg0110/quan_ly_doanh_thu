import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quan_ly_doanh_thu/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/components/my_list_tile.dart';
import 'package:quan_ly_doanh_thu/pages/profile/profile_screen.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/my_user_bloc/my_user_bloc.dart';
import '../signin/bloc/signin_bloc/signin_bloc.dart';

class MyDrawer extends StatefulWidget {
  final void Function()? onShippingOrderTap;
  final void Function()? onPersonnelTap;
  final void Function()? onTransactionTap;
  final void Function()? onCustomerTap;
  final void Function()? onCarTap;
  final void Function()? onDriverTap;
  final void Function()? onCategoryTap;

  const MyDrawer(
      {super.key,
      this.onShippingOrderTap,
      this.onTransactionTap,
      this.onCustomerTap,
      this.onCarTap,
      this.onDriverTap,
      this.onPersonnelTap,
      this.onCategoryTap,
      });

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
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Drawer(
          backgroundColor: Colors.white,
          child: Column(
            children: [
              BlocBuilder<MyUserBloc, MyUserState>(
                builder: (context, state) {
                  if (state.status == MyUserStatus.success) {
                    return Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: Column(
                        children: [
                          state.user!.picture == ""
                              ? GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ProfilePage(
                                                user: MyUser.empty)));
                                    // final ImagePicker picker = ImagePicker();
                                    // final XFile? image = await picker.pickImage(
                                    //     source: ImageSource.gallery,
                                    //     maxHeight: 500,
                                    //     maxWidth: 500,
                                    //     imageQuality: 40
                                    // );
                                    // if (image != null) {
                                    //   CroppedFile? croppedFile = await ImageCropper().cropImage(
                                    //     sourcePath: image.path,
                                    //     aspectRatio: const CropAspectRatio(
                                    //         ratioX: 1,
                                    //         ratioY: 1
                                    //     ),
                                    //     // aspectRatioPresets: [
                                    //     //   CropAspectRatioPreset.square
                                    //     // ],
                                    //     uiSettings: [
                                    //       AndroidUiSettings(
                                    //           toolbarTitle: 'Cropper',
                                    //           toolbarColor: Theme.of(context).colorScheme.primary,
                                    //           toolbarWidgetColor:Colors.white,
                                    //           initAspectRatio: CropAspectRatioPreset.original,
                                    //           lockAspectRatio: false
                                    //       ),
                                    //       IOSUiSettings(
                                    //         title: 'Cropper',
                                    //       ),
                                    //     ],
                                    //   );
                                    //   if(croppedFile != null) {
                                    //     setState(() {
                                    //       // context.read<UpdateUserInfoBloc>().add(
                                    //       //     UploadPicture(
                                    //       //         croppedFile.path,
                                    //       //         context.read<MyUserBloc>().state.user!.userId
                                    //       //     )
                                    //       // );
                                    //     });
                                    //   }
                                    // }
                                  },
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        shape: BoxShape.circle),
                                    child: Icon(CupertinoIcons.person,
                                        color: Colors.grey.shade400),
                                  ),
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            state.user!.picture!,
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                          const SizedBox(width: 10),
                          Text(
                            state.user!.name,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              // MyListTile(
              //   icon: Icons.home,
              //   text: 'TRANG CHỦ',
              //   onTap: () => Navigator.pop(context),
              // ),
              if (state.role == 'admin') ...[
                MyListTile(
                  icon: Icons.person,
                  text: 'NHÂN VIÊN',
                  onTap: widget.onPersonnelTap,
                ),
              ],
              MyListTile(
                icon: FontAwesomeIcons.truckFast,
                text: 'LỆNH VẬN CHUYỂN',
                onTap: widget.onShippingOrderTap,
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
                icon: CupertinoIcons.car_detailed,
                text: 'XE',
                onTap: widget.onCarTap,
              ),
              MyListTile(
                icon: CupertinoIcons.car,
                text: 'LÁI XE',
                onTap: widget.onDriverTap,
              ),
              MyListTile(
                icon: CupertinoIcons.square_list_fill,
                text: 'DỊCH VỤ',
                onTap: widget.onCategoryTap,
              ),
              const SizedBox(height: 50.0),
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
      },
    );
  }
}
