import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/get_transaction_bloc/get_Transaction_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../transaction/transaction_screen.dart';

class MainScreen extends StatelessWidget {
  // final List<Expense> expenses;
  final List<Transactions> transaction;

  const MainScreen(this.transaction, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Column(
              children: [
                Container(
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
                    child: BlocBuilder<GetTransactionBloc, GetTransactionState>(
                        builder: (context, state) {
                      if (state is GetTransactionSuccess) {
                        state.transaction
                            .sort((a, b) => b.date.compareTo(a.date));
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final tomorrow = today.add(const Duration(days: 1));

                        final incomesOfDay = state.transaction
                            .where((transaction) =>
                                transaction.date.isAfter(today) &&
                                transaction.date.isBefore(tomorrow))
                            .toList();

                        int totalIncome = 0;
                        for (var transaction in incomesOfDay) {
                          if (transaction.bills == 'thu') {
                            // Assuming you have a type property
                            totalIncome += transaction.amount;
                          }
                        }

                        final formatter = NumberFormat("#,##0");
                        String formattedTotalIncome =
                            formatter.format(totalIncome);
                        // final transaction = state.transaction;
                        // int totalIcome = 0;
                        // for (var transaction in transaction) {
                        //   totalIcome += transaction.amount;
                        // }
                        // final formatter = NumberFormat("#,##0");
                        // String fomattedTotal = formatter.format(totalIcome);
                        return FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Colors.white30,
                                      shape: BoxShape.circle),
                                  child: const Center(
                                      child: Icon(
                                    CupertinoIcons.arrow_up,
                                    size: 30,
                                    color: Colors.greenAccent,
                                  )),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'THU',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formattedTotalIncome,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        // const Text(" VND",
                                        //     style: TextStyle(
                                        //         fontSize: 20,
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })),
                const SizedBox(height: 20),
                Container(
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
                    child: BlocBuilder<GetTransactionBloc, GetTransactionState>(
                        builder: (context, state) {
                      if (state is GetTransactionSuccess) {
                        state.transaction
                            .sort((a, b) => b.date.compareTo(a.date));
                        final now = DateTime.now();
                        final today = DateTime(now.year, now.month, now.day);
                        final tomorrow = today.add(const Duration(days: 1));

                        final expensesOfDay = state.transaction
                            .where((transaction) =>
                                transaction.date.isAfter(today) &&
                                transaction.date.isBefore(tomorrow))
                            .toList();

                        int totalRevenue = 0;
                        for (var transaction in expensesOfDay) {
                          if (transaction.bills == 'chi') {
                            // Assuming you have a type property
                            totalRevenue += transaction.amount;
                          }
                        }

                        final formatter = NumberFormat("#,##0");
                        String formattedTotalRevenue =
                            formatter.format(totalRevenue);
                        // final expenses = state.expenses;
                        // int totalExpense = 0;
                        // for (var expense in expenses) {
                        //   totalExpense += expense.amount;
                        // }
                        // final formatter = NumberFormat("#,##0");
                        // String fomattedTotal = formatter.format(totalExpense);
                        return FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Colors.white30,
                                      shape: BoxShape.circle),
                                  child: const Center(
                                      child: Icon(
                                    CupertinoIcons.arrow_down,
                                    size: 30,
                                    color: Colors.red,
                                  )),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'CHI',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          formattedTotalRevenue,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        // const Text(" VND",
                                        //     style: TextStyle(
                                        //         fontSize: 20,
                                        //         color: Colors.white,
                                        //         fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    })),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giao Dịch',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<Expense>(
                        builder: (BuildContext context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  GetTransactionBloc(FirebaseTransactionRepo())
                                    ..add(GetTransaction()),
                            ),
                          ],
                          child: const TransactionScreen(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Xem Tất Cả',
                    style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemCount: transaction.length,
                  itemBuilder: (context, int i) {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final tomorrow = today.add(const Duration(
                        days:
                            1)); // Filter expenses to include only transactions of the day
                    final transactionOfDay = transaction
                        .where((transaction) =>
                            transaction.date.isAfter(today) &&
                            transaction.date.isBefore(tomorrow))
                        .toList();

                    if (transactionOfDay.length > i) {
                      // Check if enough elements exist
                      final transaction =
                          transactionOfDay[i]; // Access the filtered list
                      final formatter = NumberFormat("#,##0");
                      String formattedTotal =
                          formatter.format(transaction.amount);
                      // final expense = expenses[i].amount;
                      // final formatter = NumberFormat("#,##0");
                      // String formattedTotal =
                      //     formatter.format(expenses[i].amount);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: FittedBox(
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
                                      if (transaction.bills == 'thu') ...[
                                        Column(
                                          children: [
                                            Text(
                                              'Tên lệnh',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Text(
                                              transaction.shippingOrder.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              'Khách hàng',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                            Text(
                                              transaction
                                                  .shippingOrder.customer.name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      // Stack(
                                      //   alignment: Alignment.center,
                                      //   children: [
                                      //     Container(
                                      //       width: 50,
                                      //       height: 50,
                                      //       decoration: BoxDecoration(
                                      //           color: Color(
                                      //               expenses[i].category.color),
                                      //           shape: BoxShape.circle),
                                      //     ),
                                      //     Image.asset(
                                      //       'assets/${expenses[i].category.icon}.png',
                                      //       scale: 2,
                                      //       color: Colors.white,
                                      //     )
                                      //   ],
                                      // ),
                                      const SizedBox(width: 12),
                                      if (transaction.bills == 'chi') ...[
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  'Tên dịch vụ',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onBackground,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Text(
                                                  transaction.category.name,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 12),
                                            Column(
                                              children: [
                                                Text('Tên xe',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                                Text('19e123445',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        formattedTotal,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: transaction.bills == 'thu'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yy hh:mm')
                                            .format(transaction.date),
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
                        ),
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Or any other placeholder widget
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
