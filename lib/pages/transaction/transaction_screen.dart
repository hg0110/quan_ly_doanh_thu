import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/car/blocs/get_car_bloc/get_car_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/dateRangePicker.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/transaction.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/transaction_detail.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../service/blocs/create_category_bloc/create_category_bloc.dart';
import '../service/blocs/get_categories_bloc/get_categories_bloc.dart';
import '../shipping_order/blocs/get_shipping_order_bloc/get_shipping_order_bloc.dart';
import 'blocs/create_transaction_bloc/create_transaction_bloc.dart';
import 'blocs/get_transaction_bloc/get_Transaction_bloc.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Lọc giao dịch'),
            content: _buildFilterContent(context),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Đóng'),
              ),
            ],
          ),
    );
  }

  Widget _buildFilterContent(BuildContext context) {
    final state = context
        .read<GetTransactionBloc>()
        .state;
    final state1 = context
        .read<GetCarBloc>()
        .state;
    if (state is! GetTransactionSuccess || state1 is! GetCarSuccess) {
      return const Center(child: CircularProgressIndicator());
    }

    final transactions = state.transaction;
    final cars =
    transactions.map((t) => t.shippingOrder.car.BKS).toSet().toList();
    final cars1 =
    transactions.map((t) => t.car.BKS).toSet().toList();
    DateTimeRange? selectedDateRange;
    String? selectedCarId;
    String? selectedBills;

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Loại giao dịch'),
              value: selectedBills,
              items: const [
                DropdownMenuItem(value: 'thu', child: Text('Thu')),
                DropdownMenuItem(value: 'chi', child: Text('Chi')),
              ],
              onChanged: (bills) => setState(() => selectedBills = bills),
            ),
            const SizedBox(height: 16),
            if (selectedBills == 'thu') ...[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Chọn xe'),
                value: selectedCarId,
                items: cars.map((car) {
                  // Change cars to filteredCars
                  return DropdownMenuItem(
                    value: car,
                    child: Row(
                      children: [
                        Text(car),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (BKS) => setState(() => selectedCarId = BKS),
              ),
            ],
            const SizedBox(height: 16),
            if (selectedBills == 'chi') ...[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Chọn xe'),
                value: selectedCarId,
                items: cars1.map((car) {
                  // Change cars to filteredCars
                  return DropdownMenuItem(
                    value: car,
                    child: Text(car),
                  );
                }).toList(),
                onChanged: (BKS) => setState(() => selectedCarId = BKS),
              ),
            ],
            const SizedBox(height: 16),
            DateRangePicker(
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              onDateChanged: (dateRange) =>
                  setState(() => selectedDateRange = dateRange),
            ),
            const SizedBox(height: 16),
            if (selectedCarId != null && selectedDateRange != null)
              _buildFilteredResults(
                transactions,
                selectedCarId!,
                selectedDateRange!,
                selectedBills,
              ),
          ],
        );
      },
    );
  }

  Widget _buildFilteredResults(List<Transactions> transactions,
      String BKS, DateTimeRange dateRange, String? bills) {
    final filteredTransactions = transactions.where((t) {
      final matchesCar = t.car.BKS == BKS || t.shippingOrder.car.BKS == BKS;
      final matchesDate = t.date.isAfter(dateRange.start) &&
          !t.date.isBefore(dateRange.end);
      final matchesBills = bills == null || t.bills == bills;
      return matchesCar && matchesDate && matchesBills;
    }).toList();

    final income = filteredTransactions
        .where((t) => t.bills == 'thu')
        .map((transaction) => transaction.amount.toDouble())
        .fold<double>(0, (previousValue, element) => previousValue + element);
    final expense = filteredTransactions
        .where((t) => t.bills == 'chi')
        .map((transaction) => transaction.amount.toDouble())
        .fold<double>(0, (previousValue, element) => previousValue + element);

    return Column(
      children: [
        Text('Tổng thu: $income',style: const TextStyle(
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.bold),),
        Text('Tổng chi: $expense',style: const TextStyle(
            fontSize: 18,
            color: Colors.red,
            fontWeight: FontWeight.bold),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
        title: const Text(
          "Giao dịch",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              // do something
              _showFilterDialog(context);
            },
          )
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery
                  .sizeOf(context)
                  .height * 0.80,
              width: MediaQuery
                  .sizeOf(context)
                  .width,
              child: BlocBuilder<GetTransactionBloc, GetTransactionState>(
                builder: (context, state) {
                  if (state is GetTransactionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is GetTransactionSuccess) {
                    state.transaction.sort((a, b) => b.date.compareTo(a.date));
                    //Tong Thu
                    final transaction = state.transaction;
                    int totalIncome = 0;
                    for (var transaction in transaction) {
                      if (transaction.bills == 'thu') {
                        // Assuming you have a type property
                        totalIncome += transaction.amount;
                      }
                    }
                    final formatter = NumberFormat("#,##0");
                    String fomattedTotalIncome = formatter.format(totalIncome);
                    //Tong chi
                    int totalExpense = 0;
                    for (var transaction1 in transaction) {
                      if (transaction1.bills == 'chi') {
                        // Assuming you have a type property
                        totalExpense += transaction1.amount;
                      }
                    }
                    final formatter1 = NumberFormat("#,##0");
                    String fomattedTotalExpense =
                    formatter1.format(totalExpense);
                    //
                    int totalRevenue = totalIncome - totalExpense;
                    final formatter2 = NumberFormat("#,##0");
                    String formattedNetIncome = formatter2.format(totalRevenue);

                    return Column(
                      children: [
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme
                                          .of(context)
                                          .colorScheme
                                          .primary,
                                      Theme
                                          .of(context)
                                          .colorScheme
                                          .secondary,
                                      Theme
                                          .of(context)
                                          .colorScheme
                                          .tertiary,
                                    ],
                                    transform: const GradientRotation(pi / 4),
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 4,
                                        color: Colors.grey.shade300,
                                        offset: const Offset(5, 5))
                                  ]),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Tổng thu: $fomattedTotalIncome",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Tổng chi: $fomattedTotalExpense",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Doanh thu: $formattedNetIncome",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        // TextButton(
                        //   child: const Icon(Icons.filter_alt,color: Colors.black),
                        //   onPressed: (){
                        //     _showFilterDialog(context);
                        //   },
                        // ),
                        // const SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                              itemCount: state.transaction.length,
                              itemBuilder: (context, int i) {
                                final transaction = state.transaction[i];
                                final transactions =
                                    state.transaction[i].amount;
                                final formatter = NumberFormat("#,##0");
                                String formattedTotal =
                                formatter.format(transactions);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: FittedBox(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionDetail(
                                                      transaction: transaction),
                                            ));
                                      },
                                      child: Card(
                                        shadowColor: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  if (state.transaction[i]
                                                      .bills ==
                                                      'thu') ...[
                                                    Column(
                                                      children: [
                                                        Text(
                                                          'Lệnh',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Theme
                                                                .of(
                                                                context)
                                                                .colorScheme
                                                                .onBackground,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          state
                                                              .transaction[i]
                                                              .shippingOrder
                                                              .name,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Theme
                                                                .of(
                                                                context)
                                                                .colorScheme
                                                                .onBackground,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          'Khách hàng',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Theme
                                                                .of(
                                                                context)
                                                                .colorScheme
                                                                .onBackground,
                                                            fontWeight:
                                                            FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          state
                                                              .transaction[i]
                                                              .shippingOrder
                                                              .customer
                                                              .name,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Theme
                                                                .of(
                                                                context)
                                                                .colorScheme
                                                                .onBackground,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                  const SizedBox(width: 12),
                                                  if (state.transaction[i]
                                                      .bills ==
                                                      'chi') ...[
                                                    Row(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text(
                                                              'Dịch vụ',
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme
                                                                    .of(
                                                                    context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              state
                                                                  .transaction[
                                                              i]
                                                                  .category
                                                                  .name,
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Theme
                                                                      .of(
                                                                      context)
                                                                      .colorScheme
                                                                      .onBackground,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),
                                                        Column(
                                                          children: [
                                                            Text(
                                                              "Xe",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme
                                                                    .of(
                                                                    context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              state
                                                                  .transaction[
                                                              i]
                                                                  .car
                                                                  .BKS,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme
                                                                    .of(
                                                                    context)
                                                                    .colorScheme
                                                                    .onBackground,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              const SizedBox(width: 15),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        formattedTotal,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: state
                                                                .transaction[
                                                            i]
                                                                .bills ==
                                                                'thu'
                                                                ? Colors.green
                                                                : Colors.red,
                                                            fontWeight:
                                                            FontWeight
                                                                .w400),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    DateFormat('dd/MM/yy hh:mm')
                                                        .format(state
                                                        .transaction[i]
                                                        .date),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme
                                                            .of(context)
                                                            .colorScheme
                                                            .outline,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute<Transactions>(
              builder: (BuildContext context) =>
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            CreateCategoryBloc(FirebaseTransactionRepo()),
                      ),
                      BlocProvider(
                        create: (context) =>
                        GetCategoriesBloc(FirebaseTransactionRepo())
                          ..add(GetCategories()),
                      ),
                      BlocProvider(
                        create: (context) =>
                            CreateTransactionBloc(FirebaseTransactionRepo()),
                      ),
                      BlocProvider(
                          create: (context) =>
                          GetShippingOrderBloc(FirebaseShippingOrderRepo())
                            ..add(GetShippingOrder())),
                    ],
                    child: const Transaction(),
                  ),
            ),
          );
        },
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

// Function to count transactions by vehicle and display the results
// void _countTransactionsByVehicle(BuildContext context) {
//   final state =
//       context.read<GetTransactionBloc>().state; // Access the state here
//
//   if (state is GetTransactionSuccess) {
//     // Get unique vehicle BKS from transactions
//     final vehicleBKS = <String>{};
//     for (var transaction in state.transaction) {
//       // Use state.transaction
//       vehicleBKS.add(transaction.car.BKS);
//     }
//
//     // Calculate counts for each vehicle
//     final counts = <String, int>{};
//     for (var bks in vehicleBKS) {
//       counts[bks] = state.transaction
//           .where((t) => t.car.BKS == bks)
//           .length; // Use state.transaction
//     }
//
//     // Show the results in a dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Transaction Counts by Vehicle'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: counts.entries
//               .map((entry) => Text('${entry.key}: ${entry.value}'))
//               .toList(),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Close'),
//           ),
//         ],
//       ),
//     );
//   }
// }
}
