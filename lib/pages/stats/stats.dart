import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/pages/stats/chart.dart';
import 'package:quan_ly_doanh_thu/pages/stats/day_chart.dart';
import 'package:transaction_repository/transaction_repository.dart';

class StatScreen extends StatefulWidget {
  final String title;

  // final Transactions transactions;
  const StatScreen({super.key, required this.title});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  // double totalRevenue = 0;
  // double totalExpenses = 0;
  List<double> revenueData = [];
  List<double> expensesData = [];
  String selectedPeriod = 'day'; // Default to 'day'
  final _transactionRepository = FirebaseTransactionRepo();
  List<Transactions> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // 1. Fetch data from your data source based on selectedPeriod
    final transactions =
        await _transactionRepository.fetchTransactions(selectedPeriod);

    // 2. Calculate totals
    setState(() {
      // transactions = fetchedTransactions; // Update transactions here
      revenueData = transactions
          .where((t) => t.bills == 'thu')
          .map((t) => t.amount.toDouble())
          .toList();
      expensesData = transactions
          .where((t) => t.bills == 'chi')
          .map((t) => t.amount.toDouble())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // 1. Add period selection (DropdownButton, RadioButtons, etc.)
          DropdownButton<String>(
            value: selectedPeriod,
            items: const [
              DropdownMenuItem(value: 'day', child: Text('Day')),
              DropdownMenuItem(value: 'month', child: Text('Month')),
              DropdownMenuItem(value: 'year', child: Text('Year')),
            ],
            onChanged: (value) {
              setState(() {
                selectedPeriod = value!;
                _fetchData(); // Re-fetch data when period changes
              });
            },
          ),

          // 2. Display the chart
          Expanded(
            child: MyChart(
              revenueData: revenueData,
              expensesData: expensesData,
              period: selectedPeriod,
              transactions: transactions,
            ),
          ),
        ],
      ),
    );

    // return SafeArea(
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         const Text(
    //           'Thống kê doanh thu',
    //           style: TextStyle(
    //               fontSize: 20,
    //               fontWeight: FontWeight.bold
    //           ),
    //         ),
    //         const SizedBox(height: 20),
    //         Container(
    //             width: MediaQuery.of(context).size.width,
    //             height: MediaQuery.of(context).size.width,
    //             decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(12)
    //             ),
    //             child: const Padding(
    //               padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
    //               child: MyChart(),
    //             )
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
