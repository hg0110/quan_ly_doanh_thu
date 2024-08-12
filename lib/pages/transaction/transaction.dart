import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/add_expense.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/add_income.dart';

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
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    SizedBox(
                      // height: 100,
                      width: 500,
                      child: Tab(
                        text: " PHIẾU CHI ",
                      ),
                    ),
                    SizedBox(
                      width: 500,
                      child: Tab(
                        text: " PHIẾU THU ",
                      ),
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
