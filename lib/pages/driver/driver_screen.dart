import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/driver/add_driver.dart';
import 'package:quan_ly_doanh_thu/pages/driver/blocs/get_driver_bloc/get_driver_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/driver/update_driver.dart';

import 'blocs/create_driver_bloc/create_driver_bloc.dart';
import 'blocs/delete_driver_bloc/delete_driver_bloc.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  late Driver driver;
  bool isLoading = false;

  @override
  void initState() {
    driver = Driver.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreateDriverBloc, CreateDriverState>(
          listener: (context, state) {
            if (state is CreateDriverSuccess) {
              context.read<GetDriverBloc>().add(GetDriver());
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Thêm Lái xe thành công!')));
            } else if (state is CreateDriverLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is CreateDriverFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không thể thêm Lái xe')),
              );
              setState(() {
                isLoading = false;
              });
            }
          },
        ),
        BlocListener<DeleteDriverBloc, DeleteDriverState>(
          listener: (context, state) {
            if (state is DeleteDriverSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa lái xe thành công')),
              );
              context
                  .read<GetDriverBloc>()
                  .add(GetDriver()); // Refresh driver list
            } else if (state is DeleteDriverFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Không xóa được lái xe')),
              );
            }
            context.read<GetDriverBloc>().add(GetDriver());
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            "Lái Xe",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.80,
            width: MediaQuery.sizeOf(context).width,
            child: BlocBuilder<GetDriverBloc, GetDriverState>(
              builder: (context, state) {
                if (state is GetDriverLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetDriverSuccess) {
                  state.driver.sort((a, b) => b.date.compareTo(a.date));
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.driver.length,
                    itemBuilder: (context, index) {
                      final Driver driver = state.driver[index];
                      return Dismissible(
                        key: Key(driver.driverId),
                        confirmDismiss: (direction) async {
                          if (driver.status == 'đang hoạt động') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Không thể xóa lái xe đang hoạt động')),
                            );
                            return false; // Prevent dismissal
                          } else {
                          return await _showDeleteConfirmationDialog(
                              context, driver);
                          }
                        },
                        onDismissed: (direction) {
                          context
                              .read<DeleteDriverBloc>()
                              .add(DeleteDriver(driver.driverId));
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          surfaceTintColor: Colors.green,
                          shadowColor: Colors.green,
                          child: ListTile(
                            title: Row(
                              children: [
                                const Text("Họ tên: "),
                                Flexible(
                                    child: Text(driver.name,
                                        overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Địa chỉ: "),
                                    Flexible(
                                        child: Text(driver.address,
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Số điện thoại: "),
                                    Text(driver.phone),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Ghi chú: "),
                                    Flexible(
                                        child: Text(
                                      driver.note,
                                      textAlign: TextAlign.justify,
                                    )),
                                  ],
                                ),
                                // Text(
                                //   DateFormat('dd/MM/yy hh:mm')
                                //       .format(driver.date),
                                //   style: TextStyle(
                                //       fontSize: 14,
                                //       color:
                                //           Theme.of(context).colorScheme.outline,
                                //       fontWeight: FontWeight.w400),
                                // ),
                                Row(
                                  children: [
                                    const Text("Trạng thái: "),
                                    Text(driver.status,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: driver.status ==
                                                    'đang hoạt động'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () async {
                                        await UpdateDriverScreen(
                                            context, driver);
                                        context
                                            .read<GetDriverBloc>()
                                            .add(GetDriver());
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
                  );
                } else {
                  return const Center(
                    child: Text("Lỗi hiển thị"),
                  );
                }
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await getAddDriver(context);

            context.read<GetDriverBloc>().add(GetDriver());
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext parentContext, Driver driver) async {
    bool confirmDelete = false;
    await showDialog<void>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn xóa Lái xe ${driver.name} không?'),
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
                parentContext
                    .read<DeleteDriverBloc>()
                    .add(DeleteDriver(driver.driverId));
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
