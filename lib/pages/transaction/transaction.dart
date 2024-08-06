import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/pages/add_expense/add_expense.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/add_income.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/add_expense.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            // title: Text("TRANSACTION"),
            ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              // ignore: prefer_const_literals_to_create_immutables
              // Container(
              //   width: 300,
              //   height: 50,
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(30), color: Colors.white, border: Border.all(color: Colors.black)),
              //   child: TabBar(
              //     indicator: BoxDecoration(
              //       color: Colors.green,
              //       border: Border.all(color: Colors.green),
              //       borderRadius: BorderRadius.circular(20),
              //       // border: Border.all(color: Colors.grey)
              //     ),
              //     labelColor: Colors.white,
              //     // dividerColor: Colors.black,
              //     // unselectedLabelColor: Colors.black,
              //     // ignore: prefer_const_literals_to_create_immutables
              //     tabs: [
              //       const Tab(
              //         text: " EXPENSE ",
              //       ),
              //       const Tab(
              //         text: " INCOME ",
              //       ),
              //
              //     ],
              //   ),
              // ),
              Container(
                height: kToolbarHeight - 8.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TabBar(
                  // controller: _tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: Colors.green),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,

                  tabs: const [
                    Tab(
                      text: " PHIẾU CHI ",
                    ),
                    Tab(
                      text: " PHIẾU THU ",
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(children: [AddTransaction(), AddIncome()]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
