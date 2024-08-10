import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/car/add_car.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/create_car_bloc/create_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/car/update_car.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

import 'blocs/delete_car_bloc/delete_car_bloc.dart';

class CarScreen extends StatefulWidget {
  const CarScreen({super.key});

  @override
  State<CarScreen> createState() => _CarScreenState();
}

class _CarScreenState extends State<CarScreen> {
  late Car car;
  bool isLoading = false;

  @override
  void initState() {
    car = Car.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CreateCarBloc, CreateCarState>(
            listener: (context, state) {
              if (state is CreateCarSuccess) {
                Navigator.pop(context, car);
                context.read<GetCarBloc>().add(GetCar());
              } else if (state is CreateCarLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is CreateCarFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không thể thêm xe')),
                );
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          BlocListener<DeleteCarBloc, DeleteCarState>(
            listener: (context, state) {
              if (state is DeleteCarSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa xe thành công')),
                );
                context.read<GetCarBloc>().add(GetCar());
              } else if (state is DeleteCarFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không xóa được xe')),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Text(
              "Xe",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.80,
            width: MediaQuery.sizeOf(context).width,
            child: BlocBuilder<GetCarBloc, GetCarState>(
              builder: (context, state) {
                if (state is GetCarLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetCarSuccess) {
                  state.car
                      .sort((a, b) => b.date.compareTo(a.date));
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.car.length,
                    itemBuilder: (context, index) {
                      final Car car = state.car[index];
                      return Dismissible(
                        key: Key(car.carId),
                        onDismissed: (direction) {
                          _showDeleteConfirmationDialog(context, car);
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
                                const Text("Tên Xe: "),
                                Text(car.name),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Số hiệu: "),
                                    Text(car.BKS),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Ghi chú: "),
                                    Text(car.note),
                                  ],
                                ),
                                Text(
                                  DateFormat('dd/MM/yy hh:mm')
                                      .format(car.date),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed:  ()async{
                                         await UpdateCarScreen(context, car);
                                        context.read<GetCarBloc>().add(GetCar());
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
                    child: Text("Error"),
                  );
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var newCar = await getAddCar(context);
              if (newCar != null) {
                context.read<GetCarBloc>().add(GetCar());
              }
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Car car) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete car ${car.name}?'),
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
                context.read<DeleteCarBloc>().add(DeleteCar(car.carId));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
