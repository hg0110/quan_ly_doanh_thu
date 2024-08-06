import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/shipping_order/blocs/get_shipping_order_bloc/get_shipping_order_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/create_transaction_bloc/create_transaction_bloc.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

import 'blocs/get_transaction_bloc/get_Transaction_bloc.dart';

class AddIncome extends StatefulWidget {
  const AddIncome({super.key});

  @override
  State<AddIncome> createState() => _AddIncomeState();
}

final List<String> genderItems = [
  'THU',
  'CHI',
];

// String? selectedValue;

class _AddIncomeState extends State<AddIncome> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectDate = DateTime.now();
  bool isLoading = false;
  String? selectedShippingOrder;

  // Customer customer = Customer.empty;
  ShippingOrder shippingOrder = ShippingOrder.empty;

  // late Income income;
  late Transactions transactions;

  // Customer? selectedCustomerID;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    // expense = Expense.empty;
    // expense.expenseId = const Uuid().v1();
    // income = Income.empty;
    transactions = Transactions.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateTransactionBloc, CreateTransactionState>(
      listener: (BuildContext context, state) {
        if (state is CreateTransactionSuccess) {
          Navigator.pop(context, transactions);
          context.read<GetTransactionBloc>().add(GetTransaction());
        } else if (state is CreateTransactionLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: Scaffold(
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
                      DropdownButton<String>(
                        hint: selectedShippingOrder == null
                            ? const Text('Lệnh vận chuyển')
                            : Text(
                                selectedShippingOrder!,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 13),
                              ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: const TextStyle(color: Colors.blue),
                        value: selectedShippingOrder,
                        // Store the selected  ID
                        items: state.shippingOrder.map((shippingOrder) {
                          return DropdownMenuItem<String>(
                            value: shippingOrder.name,
                            child: Row(
                              children: [
                                Text(shippingOrder.name),
                                Text(shippingOrder.customer.name),
                                Text(shippingOrder.car.BKS),
                                // Text(shippingOrder.driver.driverId),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedShippingOrder = newValue!;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      // DropdownButton<String>(
                      //   hint: selectedCustomerId == null
                      //       ? const Text('Customer')
                      //       : Text(
                      //           selectedCustomerId!,
                      //           style: const TextStyle(
                      //               color: Colors.green, fontSize: 13),
                      //         ),
                      //   isExpanded: true,
                      //   iconSize: 30.0,
                      //   style: const TextStyle(color: Colors.blue),
                      //   value: selectedCustomer?.customerId,
                      //   // Store the selected  ID
                      //   items: state.customer.map((customer) {
                      //     return DropdownMenuItem<String>(
                      //       value: customer.name,
                      //       child: Text(customer.name),
                      //     );
                      //   }).toList(),
                      //   onChanged: (String? newValue) {
                      //     setState(() {
                      //       selectedCustomer = state.customer.firstWhere(
                      //           (customer) => customer.customerId == newValue);
                      //       // selectedCustomerId = newValue!;
                      //     });
                      //   },
                      // ),
                      const SizedBox(
                        height: 32,
                      ),
                      // DropdownButton<String>(
                      //   isExpanded: true,
                      //   // decoration: InputDecoration(
                      //   //   // Add Horizontal padding using menuItemStyleData.padding so it matches
                      //   //   // the menu padding when button's width is not specified.
                      //   //   contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      //   //   border: OutlineInputBorder(
                      //   //     borderRadius: BorderRadius.circular(15),
                      //   //   ),
                      //   //   // Add more decoration..
                      //   // ),
                      //   hint: const Text(
                      //     'Chon giao dich',
                      //     style: TextStyle(fontSize: 14),
                      //   ),
                      //   items: genderItems
                      //       .map((item) => DropdownMenuItem<String>(
                      //             value: item,
                      //             child: Text(
                      //               item,
                      //               style: const TextStyle(
                      //                 fontSize: 14,
                      //               ),
                      //             ),
                      //           ))
                      //       .toList(),
                      //   // validator: (value) {
                      //   //   if (value == null) {
                      //   //     return 'Please select gender.';
                      //   //   }
                      //   //   return null;
                      //   // },
                      //   onChanged: (value) {
                      //     //Do something when selected item is changed.
                      //   },
                      //   // onSaved: (value) {
                      //   //   selectedValue = value.toString();
                      //   // },
                      //   // buttonStyleData: const ButtonStyleData(
                      //   //   padding: EdgeInsets.only(right: 8),
                      //   // ),
                      //   // iconStyleData: const IconStyleData(
                      //   //   icon: Icon(
                      //   //     Icons.arrow_drop_down,
                      //   //     color: Colors.black45,
                      //   //   ),
                      //   //   iconSize: 24,
                      //   // ),
                      //   // dropdownStyleData: DropdownStyleData(
                      //   //   decoration: BoxDecoration(
                      //   //     borderRadius: BorderRadius.circular(15),
                      //   //   ),
                      //   // ),
                      //   // menuItemStyleData: const MenuItemStyleData(
                      //   //   padding: EdgeInsets.symmetric(horizontal: 16),
                      //   // ),
                      // ),
                      // TextFormField(
                      //   controller: categoryController,
                      //   textAlignVertical: TextAlignVertical.center,
                      //   readOnly: true,
                      //   onTap: () {},
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: expense.category == Category.empty
                      //         ? Colors.white
                      //         : Color(expense.category.color),
                      //     prefixIcon: expense.category == Category.empty
                      //         ? const Icon(
                      //       FontAwesomeIcons.list,
                      //       size: 16,
                      //       color: Colors.grey,
                      //     )
                      //         : Image.asset(
                      //       'assets/${expense.category.icon}.png',
                      //       scale: 2,
                      //     ),
                      //     suffixIcon: IconButton(
                      //         onPressed: () async {
                      //           var newCategory =
                      //           await getCategoryCreation(context);
                      //           setState(() {
                      //             state.categories.insert(0, newCategory);
                      //           });
                      //         },
                      //         icon: const Icon(
                      //           FontAwesomeIcons.plus,
                      //           size: 16,
                      //           color: Colors.grey,
                      //         )),
                      //     hintText: 'Category',
                      //     border: const OutlineInputBorder(
                      //         borderRadius: BorderRadius.vertical(
                      //             top: Radius.circular(12)),
                      //         borderSide: BorderSide.none),
                      //   ),
                      // ),
                      // Container(
                      //   height: 200,
                      //   width: MediaQuery.of(context).size.width,
                      //   decoration: const BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius:
                      //         BorderRadius.vertical(bottom: Radius.circular(12)),
                      //   ),
                      //   child: Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: ListView.builder(
                      //           itemCount: state.customer.length,
                      //           itemBuilder: (context, int i) {
                      //             // return Card(
                      //             //   child: ListTile(
                      //             //     onTap: () {
                      //             //       setState(() {
                      //             //         expense.category =
                      //             //         state.categories[i];
                      //             //         categoryController.text =
                      //             //             expense.category.name;
                      //             //       });
                      //             //     },
                      //             //     leading: Image.asset(
                      //             //       'assets/${state.categories[i].icon}.png',
                      //             //       scale: 2,
                      //             //     ),
                      //             //     title: Text(state.categories[i].name),
                      //             //     tileColor:
                      //             //     Color(state.categories[i].color),
                      //             //     shape: RoundedRectangleBorder(
                      //             //         borderRadius:
                      //             //         BorderRadius.circular(8)),
                      //             //   ),
                      //             // );
                      //           })),
                      // ),
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
                              lastDate: DateTime.now()
                                  .add(const Duration(days: 365)));

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
                                onPressed: () {
                                  setState(() {
                                    transactions.amount =
                                        int.parse(incomeController.text);
                                    transactions.shippingOrder.name =
                                        selectedShippingOrder!;
                                    transactions.bills = 'thu';
                                    // transactions =Transactions.empty;
                                  });

                                  context
                                      .read<CreateTransactionBloc>()
                                      .add(CreateTransaction(transactions));

                                  // setState(() {
                                  //   incomeController.clear();
                                  //   selectedShippingOrder = null;
                                  //   dateController.text =
                                  //       DateFormat('dd/MM/yyyy')
                                  //           .format(DateTime.now());
                                  //   transactions = Transactions
                                  //       .empty; // Reset transactions object
                                  // });

                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
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
      ),
    );
  }
}
