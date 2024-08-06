import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'blocs/get_transaction_bloc/get_Transaction_bloc.dart';

class TransactionScreen extends StatefulWidget {
  // final List<Transactions> transaction;
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text(
          "Giao dịch",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.80,
          width: MediaQuery.sizeOf(context).width,
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
                final transaction1 = state.transaction;
                int totalExpense = 0;
                for (var transaction1 in transaction) {
                  if (transaction1.bills == 'chi') {
                    // Assuming you have a type property
                    totalExpense += transaction1.amount;
                  }
                }
                final formatter1 = NumberFormat("#,##0");
                String fomattedTotalExpense = formatter1.format(totalExpense);
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
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).colorScheme.primary,
                                  Theme.of(context).colorScheme.secondary,
                                  Theme.of(context).colorScheme.tertiary,
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
                    const SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                          itemCount: state.transaction.length,
                          itemBuilder: (context, int i) {
                            // final now = DateTime.now();
                            // final today = DateTime(now.year, now.month, now.day);
                            // final tomorrow = today.add(const Duration(
                            //     days:
                            //     1)); // Filter expenses to include only transactions of the day
                            // final expensesOfDay = state.expenses
                            //     .where((expense) =>
                            // expense.date.isAfter(today) &&
                            //     expense.date.isBefore(tomorrow))
                            //     .toList();
                            //
                            // if (expensesOfDay.length > i) {
                            //   // Check if enough elements exist
                            //   final expense =
                            //   expensesOfDay[i]; // Access the filtered list
                            //   final formatter = NumberFormat("#,##0");
                            //   String formattedTotal = formatter.format(expense.amount);
                            final transactions = state.transaction[i].amount;
                            final formatter = NumberFormat("#,##0");
                            String formattedTotal =
                                formatter.format(transactions);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
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
                                          if (state.transaction[i].bills ==
                                              'thu') ...[
                                            Text(
                                              state.transaction[i].shippingOrder
                                                  .name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                          // Text(
                                          //   state.transaction[i].shippingOrder.name,
                                          //   style: TextStyle(
                                          //       fontSize: 14,
                                          //       color: Theme.of(context)
                                          //           .colorScheme
                                          //           .onBackground,
                                          //       fontWeight: FontWeight.w500),
                                          // ),
                                          // Stack(
                                          //   alignment: Alignment.center,
                                          //   children: [
                                          //     Container(
                                          //       width: 50,
                                          //       height: 50,
                                          //       decoration: BoxDecoration(
                                          //           color: Color(
                                          //               state.transaction[i].category.color),
                                          //           shape: BoxShape.circle),
                                          //     ),
                                          //     // Image.asset(
                                          //     //   'assets/${state.transaction[i].category.icon}.png',
                                          //     //   scale: 2,
                                          //     //   color: Colors.white,
                                          //     // )
                                          //   ],
                                          // ),
                                          const SizedBox(width: 12),
                                          if (state.transaction[i].bills ==
                                              'chi') ...[
                                            Text(
                                              state
                                                  .transaction[i].category.name,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onBackground,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(width: 15),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            formattedTotal,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: state.transaction[i]
                                                            .bills ==
                                                        'thu'
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          Text(
                                            DateFormat('dd/MM/yy hh:mm').format(
                                                state.transaction[i].date),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .outline,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            //   } else {
                            //     return const SizedBox
                            //         .shrink(); // Or any other placeholder widget
                            //   }
                          }),
                    ),
                  ],
                );
                //   ListView.builder(
                //   scrollDirection: Axis.vertical,
                //   itemCount: state.driver.length,
                //   itemBuilder: (context, index) {
                //     final Driver driver = state.driver[index];
                //     return Dismissible(
                //       key: Key(driver.driverId),
                //       onDismissed: (direction) {
                //         _showDeleteConfirmationDialog(context, driver);
                //       },
                //       background: Container(
                //         color: Colors.red,
                //         alignment: Alignment.centerRight,
                //         padding: const EdgeInsets.only(right: 16.0),
                //         child: const Icon(Icons.delete, color: Colors.white),
                //       ),
                //       child: Card(
                //         surfaceTintColor: Colors.green,
                //         shadowColor: Colors.green,
                //         child: ListTile(
                //           title: Row(
                //             children: [
                //               const Text("Họ tên: "),
                //               Text(driver.name),
                //             ],
                //           ),
                //           subtitle: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               // Row(
                //               //   children: [
                //               //     const Text("BKS: "),
                //               //     Text(driver.BKS),
                //               //   ],
                //               // ),
                //               Row(
                //                 children: [
                //                   const Text("Ghi chú: "),
                //                   Text(driver.note),
                //                 ],
                //               ),
                //             ],
                //           ),
                //           trailing: Column(
                //             children: [
                //               Expanded(
                //                 child: SizedBox(
                //                   width: 30,
                //                   child: IconButton(
                //                     icon: const Icon(Icons.edit),
                //                     onPressed:  ()async{
                //                       var updateDriver = await UpdateDriverScreen(context, driver);
                //                       context.read<GetDriverBloc>().add(GetDriver());
                //                     },
                //                   ),
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),
                //     );
                //   },
                // );
              } else {
                return const Center(
                  child: Text("Lỗi hiển thị"),
                );
              }
            },
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     var newTransaction = await const Transaction();
      //     if (newTransaction != null) {
      //       context.read<GetTransactionBloc>().add(GetTransaction());
      //     }
      //   },
      //   backgroundColor: Theme.of(context).colorScheme.secondary,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
    // Expanded(
    //   child: ListView.builder(
    //       itemCount: expenses.length,
    //       itemBuilder: (context, int i) {
    //         final now = DateTime.now();
    //         final today = DateTime(now.year, now.month, now.day);
    //         final tomorrow = today.add(const Duration(
    //             days:
    //             1)); // Filter expenses to include only transactions of the day
    //         final expensesOfDay = expenses
    //             .where((expense) =>
    //         expense.date.isAfter(today) &&
    //             expense.date.isBefore(tomorrow))
    //             .toList();
    //
    //         if (expensesOfDay.length > i) {
    //           // Check if enough elements exist
    //           final expense =
    //           expensesOfDay[i]; // Access the filtered list
    //           final formatter = NumberFormat("#,##0");
    //           String formattedTotal = formatter.format(expense.amount);
    //           // final expense = expenses[i].amount;
    //           // final formatter = NumberFormat("#,##0");
    //           // String formattedTotal =
    //           //     formatter.format(expenses[i].amount);
    //           return Padding(
    //             padding: const EdgeInsets.only(bottom: 16.0),
    //             child: Card(
    //               shadowColor: Colors.red,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(16.0),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Stack(
    //                           alignment: Alignment.center,
    //                           children: [
    //                             Container(
    //                               width: 50,
    //                               height: 50,
    //                               decoration: BoxDecoration(
    //                                   color: Color(
    //                                       expenses[i].category.color),
    //                                   shape: BoxShape.circle),
    //                             ),
    //                             Image.asset(
    //                               'assets/${expenses[i].category.icon}.png',
    //                               scale: 2,
    //                               color: Colors.white,
    //                             )
    //                           ],
    //                         ),
    //                         const SizedBox(width: 12),
    //                         Text(
    //                           expenses[i].category.name,
    //                           style: TextStyle(
    //                               fontSize: 14,
    //                               color: Theme.of(context)
    //                                   .colorScheme
    //                                   .onBackground,
    //                               fontWeight: FontWeight.w500),
    //                         ),
    //                       ],
    //                     ),
    //                     const SizedBox(width: 15),
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.end,
    //                       children: [
    //                         Text(
    //                           "$formattedTotal",
    //                           style: const TextStyle(
    //                               fontSize: 13,
    //                               color: Colors.red,
    //                               fontWeight: FontWeight.w400),
    //                         ),
    //                         Text(
    //                           DateFormat('dd/MM/yy hh:mm')
    //                               .format(expenses[i].date),
    //                           style: TextStyle(
    //                               fontSize: 14,
    //                               color: Theme.of(context)
    //                                   .colorScheme
    //                                   .outline,
    //                               fontWeight: FontWeight.w400),
    //                         ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           );
    //         } else {
    //           return const SizedBox
    //               .shrink(); // Or any other placeholder widget
    //         }
    //       }),
    // );
  }
}
