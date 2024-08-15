import 'package:driver_repository/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/blocs/get_shipping_order_bloc/get_shipping_order_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/create_transaction_bloc/create_transaction_bloc.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

class _AddIncomeState extends State<AddIncome> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();
  bool isLoading = false;
  ShippingOrder? selectedShippingOrder;

  late Transactions transactions;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    selectedShippingOrder = null;
    transactions = Transactions.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocBuilder<GetShippingOrderBloc, GetShippingOrderState>(
        builder: (context, state) {
          if (state is GetShippingOrderSuccess) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Thêm Phiếu Thu",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Colors.red),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: TextFormField(
                        controller: incomeController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(
                            FontAwesomeIcons.dollarSign,
                            size: 16,
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            // borderSide: BorderSide.none
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    DropdownButton<ShippingOrder>(
                      hint: selectedShippingOrder == null
                          ? const Text('Lệnh vận chuyển')
                          : Text(
                              selectedShippingOrder!.name,
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 16),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: const TextStyle(color: Colors.green, fontSize: 16),
                      value: selectedShippingOrder,
                      // Store the selected  ID
                      items: state.shippingOrder
                          .where((shippingOrder) =>
                              shippingOrder.status == 'đang hoạt động')
                          .map((shippingOrder) {
                        return DropdownMenuItem<ShippingOrder>(
                          value: shippingOrder,
                          child: FittedBox(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    const Text('Lệnh',
                                        style: TextStyle(color: Colors.grey)),
                                    Text(shippingOrder.name),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  children: [
                                    const Text('KH',
                                        style: TextStyle(color: Colors.grey)),
                                    Text(shippingOrder.customer.name),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  children: [
                                    const Text('Xe',
                                        style: TextStyle(color: Colors.grey)),
                                    Text(shippingOrder.car.BKS),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  children: [
                                    const Text('Lái xe',
                                        style: TextStyle(color: Colors.grey)),
                                    Text(shippingOrder.driver.name),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (ShippingOrder? newValue) {
                        setState(() {
                          selectedShippingOrder = newValue;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: dateController,
                      textAlignVertical: TextAlignVertical.center,
                      readOnly: true,
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: transactions.date,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)));

                        if (newDate != null) {
                          setState(() {
                            dateController.text =
                                DateFormat('dd/MM/yyyy').format(newDate);
                            selectDate = newDate;
                            transactions.date = newDate;
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
                        hintText: 'Date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : TextButton(
                              onPressed: () async {
                                final DriverRepo = FirebaseDriverRepo();
                                final ShippingOrderRepo =
                                    FirebaseShippingOrderRepo();
                                if (selectedShippingOrder != null) {
                                  selectedShippingOrder!.status =
                                      "đã hoàn thành";
                                  selectedShippingOrder!.car.status = "chờ";
                                  selectedShippingOrder!.driver.status = "chờ";
                                  selectedShippingOrder!.end_day =
                                      DateTime.now();
                                  await ShippingOrderRepo.updateShippingOrder(
                                      selectedShippingOrder!);
                                  await ShippingOrderRepo.updateCar(
                                      selectedShippingOrder!.car);
                                  await DriverRepo.updateDriver(
                                      selectedShippingOrder!.driver);
                                }
                                setState(() {
                                  transactions.amount =
                                      int.parse(incomeController.text);
                                  transactions.shippingOrder =
                                      selectedShippingOrder ??
                                          ShippingOrder.empty;
                                  transactions.bills = 'thu';
                                  transactions.car = Car.empty;
                                  // transactions.category = Category.empty;
                                });

                                context
                                    .read<CreateTransactionBloc>()
                                    .add(CreateTransaction(transactions));
                                Navigator.pop(context, transactions);
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                'Lưu',
                                style: TextStyle(
                                    fontSize: 22, color: Colors.white),
                              )),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
