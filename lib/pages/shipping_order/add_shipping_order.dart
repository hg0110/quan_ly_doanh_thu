import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

import '../driver/blocs/get_driver_bloc/get_driver_bloc.dart';
import 'blocs/create_shipping_order_bloc/create_shipping_order_bloc.dart';

class AddShippingOrder extends StatefulWidget {
  const AddShippingOrder({super.key});

  @override
  State<AddShippingOrder> createState() => _AddShippingOrderState();
}

class _AddShippingOrderState extends State<AddShippingOrder> {
  final TextEditingController textLenhController = TextEditingController();
  final TextEditingController textNoteController = TextEditingController();
  final TextEditingController textDateController = TextEditingController();
  bool isLoading = false;
  Car? selectedCar;
  Driver? selectedDriver;
  Customer? selectedCustomer;
  MyUser? user;

  ShippingOrder shippingOrder = ShippingOrder.empty;
  DateTime selectDate = DateTime.now();

  @override
  void initState() {
    textDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    shippingOrder = ShippingOrder.empty;
    selectedDriver = null;
    selectedCar = null;
    selectedCustomer = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDriverBloc, GetDriverState>(
        builder: (context, state) {
      if (state is GetDriverSuccess) {
        return BlocBuilder<GetCarBloc, GetCarState>(
            builder: (context1, state1) {
          if (state1 is GetCarSuccess) {
            return BlocBuilder<GetCustomerBloc, GetCustomerState>(
                builder: (context2, state2) {
              if (state2 is GetCustomerSuccess) {
                return Scaffold(
                    appBar: AppBar(
                      title: const Text('Thêm lệnh vận chuyển'),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: textLenhController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Tên lệnh',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButton<Driver>(
                              hint: selectedDriver == null
                                  ? const Text('Lái Xe')
                                  : Text(
                                      selectedDriver!.name,
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 13),
                                    ),
                              isExpanded: true,
                              iconSize: 40.0,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              value: selectedDriver,
                              items: state.driver.map((driver) {
                                return DropdownMenuItem<Driver>(
                                  value: driver,
                                  child: Row(
                                    children: [
                                      Text(driver.name),
                                      Text(driver.address),
                                      Text(driver.phone),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (Driver? newValue) {
                                setState(() {
                                  selectedDriver = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButton<Car>(
                              hint: selectedCar == null
                                  ? const Text('Xe')
                                  : Text(
                                      selectedCar!.BKS,
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 13),
                                    ),
                              isExpanded: true,
                              iconSize: 40.0,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              value: selectedCar,
                              items: state1.car.map((car) {
                                return DropdownMenuItem<Car>(
                                  value: car,
                                  child: Text(car.BKS),
                                );
                              }).toList(),
                              onChanged: (Car? newValue) {
                                setState(() {
                                  selectedCar = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButton<Customer>(
                              hint: selectedCustomer == null
                                  ? const Text('Khách hàng')
                                  : Text(
                                      selectedCustomer!.name,
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 13),
                                    ),
                              isExpanded: true,
                              iconSize: 40.0,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              value: selectedCustomer,
                              items: state2.customer.map((customer) {
                                return DropdownMenuItem<Customer>(
                                  value: customer,
                                  child: Text(customer.name),
                                );
                              }).toList(),
                              onChanged: (Customer? newValue) {
                                setState(() {
                                  selectedCustomer = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                controller: textNoteController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Ghi chú',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              children: [
                                const Text('Ngày bắt đầu: '),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: TextFormField(
                                    controller: textDateController,
                                    textAlignVertical: TextAlignVertical.center,
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? newDate = await showDatePicker(
                                          context: context,
                                          initialDate: shippingOrder.start_day,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 365)));

                                      if (newDate != null) {
                                        setState(() {
                                          textDateController.text =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(newDate);
                                          selectDate = newDate;
                                          shippingOrder.start_day = newDate;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      prefixIcon: const Icon(
                                        FontAwesomeIcons.clock,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      hintText: 'Ngày bắt đầu: ',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  shippingOrder.ShippingId = const Uuid().v1();
                                  shippingOrder.name = textLenhController.text;
                                  shippingOrder.car = selectedCar ?? Car.empty;
                                  shippingOrder.driver =
                                      selectedDriver ?? Driver.empty;
                                  shippingOrder.customer =
                                      selectedCustomer ?? Customer.empty;
                                  shippingOrder.user = user ?? MyUser.empty;
                                });
                                context
                                    .read<CreateShippingOrderBloc>()
                                    .add(CreateShippingOrder(shippingOrder));
                                textLenhController.clear();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Lưu'),
                            ),
                          ],
                        ),
                      )),
                    ));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
