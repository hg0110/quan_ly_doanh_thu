import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/customer/blocs/get_customer_bloc/get_customer_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/shipping_order_screen.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

import '../driver/blocs/get_driver_bloc/get_driver_bloc.dart';
import 'blocs/create_shipping_order_bloc/create_shipping_order_bloc.dart';
import 'blocs/get_shipping_order_bloc/get_shipping_order_bloc.dart';

class AddShippingOrder extends StatefulWidget {
  const AddShippingOrder({super.key, required this.onRefresh});

  final VoidCallback onRefresh;
  // final ShippingOrderRepository shippingOrderRepository;

  @override
  State<AddShippingOrder> createState() => _AddShippingOrderState();
}

class _AddShippingOrderState extends State<AddShippingOrder> {
  final TextEditingController textLenhController = TextEditingController();
  final TextEditingController textNoteController = TextEditingController();
  final TextEditingController textDateController = TextEditingController();
  bool isLoading = false;
  Driver driver = Driver.empty;
  Customer customer = Customer.empty;
  Car car = Car.empty;

  // final List<Driver> driver;

  ShippingOrder shippingOrder = ShippingOrder.empty;
  String? selectedDriverId;
  Driver? selectedDriver;
  String? selectedCarId;
  String? selectedCustomerId;
  DateTime selectDate = DateTime.now();

  @override
  void initState() {
    textDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    shippingOrder = ShippingOrder.empty;
    driver = Driver.empty;
    car = Car.empty;
    customer = Customer.empty;
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
                            // latte List<Driver> driver;
                            // final driverName = await DriverRepository.get;
                            DropdownButton<String>(
                              hint: selectedDriverId == null
                                  ? const Text('Lái Xe')
                                  : Text(
                                selectedDriverId!,
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 13),
                                    ),
                              isExpanded: true,
                              iconSize: 40.0,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              value: selectedDriverId,
                              // Store the selected driver ID
                              items: state.driver.map((driver) {
                                return DropdownMenuItem<String>(
                                  value: driver.name,
                                  child: Row(
                                    children: [
                                      Text(driver.name),
                                      Text(driver.address),
                                      Text(driver.phone),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  // selectedDriver = state.driver.firstWhere(
                                  //       (driver) => driver.driverId == newValue,
                                  //   orElse: () => Driver.empty, // Return an empty Driver object if no match is found
                                  // );
                                  selectedDriverId = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButton<String>(
                              hint: selectedCarId == null
                                  ? const Text('Xe')
                                  : Text(
                                      selectedCarId!,
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 13),
                                    ),
                              isExpanded: true,
                              iconSize: 40.0,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              value: selectedCarId,
                              // Store the selected  ID
                              items: state1.car.map((car) {
                                return DropdownMenuItem<String>(
                                  value: car.BKS,
                                  child: Text(car.BKS),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCarId = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            DropdownButton<String>(
                              hint: selectedCustomerId == null
                                  ? const Text('Khách hàng')
                                  : Text(
                                      selectedCustomerId!,
                                      style: const TextStyle(
                                          color: Colors.green, fontSize: 13),
                                    ),
                              isExpanded: true,
                              iconSize: 40.0,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                              value: selectedCustomerId,
                              // Store the selected  ID
                              items: state2.customer.map((customer) {
                                return DropdownMenuItem<String>(
                                  value: customer.name,
                                  child: Text(customer.name),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCustomerId = newValue;
                                  // selectedCustomerId = customer.name;
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
                              onPressed: () async{
                                // int nextOrderId = await context.read<ShippingOrderRepository>().generateNextOrderId();
                                setState(() {
                                  shippingOrder.ShippingId = const Uuid().v1();
                                  shippingOrder.name = textLenhController.text;
                                  driver.name = selectedDriverId!;
                                  car.BKS = selectedCarId!;
                                  customer.name = selectedCustomerId!;
                                });
                                context
                                    .read<CreateShippingOrderBloc>()
                                    .add(CreateShippingOrder(shippingOrder));
                                textLenhController.clear();
                                widget.onRefresh();
                                // textAddressController.clear();
                                // textPhoneController.clear();
                                // context.read<GetShippingOrderBloc>().add(GetShippingOrder());
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => BlocProvider(
                                //         create: (context) =>
                                //             GetShippingOrderBloc(
                                //                 FirebaseShippingOrderRepo())
                                //               ..add(GetShippingOrder()),
                                //         child: const ShippingOrderScreen(),
                                //       ),
                                //     ));
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
