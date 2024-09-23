import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/user/signup/signup_screen.dart';
import 'package:quan_ly_doanh_thu/pages/user/update_user.dart';
import 'package:user_repository/user_repository.dart';

import 'blocs/delete_user_bloc/delete_user_bloc.dart';
import 'blocs/get_user_bloc/get_user_bloc.dart';
import 'blocs/signup_bloc/signup_bloc.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late MyUser user;

  bool isLoading = false;

  @override
  void initState() {
    user = MyUser.empty;
    super.initState();
  }

  void _showFilterDialog(BuildContext context) {
    String? _searchTerm;

    showDialog(
      context: context,
      builder: (context) => BlocListener<GetUserBloc, GetUserState>(
        listener: (context, state) {
          if (state is GetUserSuccess && state.user.isNotEmpty) {
            _showResultDialog(context, state.user.first);
          }else if(state is GetUserNotFound){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Không tìm thấy Nhân viên')),
            );
          }
        },
        child: AlertDialog(
          title: const Text('Tìm kiếm thông tin nhân viên'),
          content: TextField(
            onChanged: (text) => _searchTerm = text,
            decoration: const InputDecoration(hintText: 'Nhập email nhân viên'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
            TextButton(
              onPressed: () {
                if (_searchTerm != null && _searchTerm!.isNotEmpty) {
                  context.read<GetUserBloc>().add(SearchUser(_searchTerm!));
                }
              },
              child: const Text('Tìm kiếm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context, MyUser employee) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin nhân viên'),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        Text('Họ tên: ${employee.name}'),
        Text('Email: ${employee.email}'),
        Text('Quyền: ${employee.roles}'),
        // Hiển thị thêm thông tin khác nếu cần
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
      ],
    ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is SignUpSuccess) {
                context.read<GetUserBloc>().add(GetUser());
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Thêm Nhân viên thành công!')));
              } else if (state is SignUpProcess) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is SignUpFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không thể thêm Nhân viên')),
                );
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          BlocListener<DeleteUserBloc, DeleteUserState>(
            listener: (context, state) {
              if (state is DeleteUserSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa nhân viên thành công')),
                );
                context
                    .read<GetUserBloc>()
                    .add(GetUser()); // Refresh driver list
              } else if (state is DeleteUserFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không xóa được nhân viên')),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Text(
              "NHÂN VIÊN",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {
                  // do something
                  _showFilterDialog(context);
                },
              )
            ],
          ),
          body: BlocBuilder<GetUserBloc, GetUserState>(
            builder: (context, state) {
              if (state is GetUserLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is GetUserSuccess) {
                state.user.sort((a, b) => b.date.compareTo(a.date));
                return Column(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Tổng số nhân viên: ${state.user.length}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: state.user.length,
                        itemBuilder: (context, index) {
                          final user = state.user[index];
                          return Dismissible(
                            key: Key(user.userId),
                            confirmDismiss: (direction) async {
                              // Use confirmDismiss
                              return await _showDeleteConfirmationDialog(
                                  context, user);
                            },
                            onDismissed: (direction) {
                              context
                                  .read<DeleteUserBloc>()
                                  .add(DeleteUser(user.userId));
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16.0),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Card(
                              surfaceTintColor: Colors.green,
                              shadowColor: Colors.green,
                              child: ListTile(
                                title: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      const Text("Họ tên: "),
                                      Flexible(
                                          child: Text(
                                        user.name,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    ],
                                  ),
                                ),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Text("Emai: "),
                                          Flexible(
                                              child: Text(
                                            user.email,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Text("Quyền: "),
                                          Text(user.roles),
                                        ],
                                      ),
                                      // Row(
                                      //   children: [
                                      //     const Text("ID: "),
                                      //     Text(user.userId),
                                      //   ],
                                      // ),
                                    ]),
                                trailing: Column(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 30,
                                        child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () async {
                                            await UpdateUserScreen(
                                                context, user);
                                            context
                                                .read<GetUserBloc>()
                                                .add(GetUser());
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: Text("Lỗi hiển thị"),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<SignUpBloc>(
                    // Provide SignUpBloc here
                    create: (context) =>
                        SignUpBloc(userRepository: FirebaseUserRepo()),
                    // Replace userRepository if needed
                    child: const Signupscreen(),
                  ),
                ),
              );
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, MyUser user) async {
    bool confirmDelete = false;
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa nhân viên ${user.name} không?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                confirmDelete = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return confirmDelete;
  }
}
