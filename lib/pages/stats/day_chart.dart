import 'dart:core';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MyChart extends StatefulWidget {
  final List<Transactions> transactions;

  const MyChart({super.key, required this.transactions});

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  List<Transactions> _currentWeekTransactions = [];
  @override
  void initState() {
    super.initState();
    _refreshData();
  }
  @override
  Widget build(BuildContext context) {
    Map<int, double> profitByDayOfWeek = _calculateProfitByDayOfWeek(_currentWeekTransactions);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          SizedBox(
            height: 400,
            child: BarChart(_barChartData(profitByDayOfWeek)),
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatisticItem(
                      'Tổng Thu: ', _calculateTotalRevenue(), Colors.green),
                  const SizedBox(width: 12),
                  _buildStatisticItem(
                      'Tổng Chi: ', _calculateTotalExpenses(), Colors.red),
                  const SizedBox(width: 12),
                  _buildStatisticItem(
                      'Lợi Nhuận: ', _calculateProfit(), Colors.blue),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalRevenue() {
    return widget.transactions
        .where((transaction) => transaction.bills == 'thu')
        .map((transaction) => transaction.amount.toDouble())
        .fold<double>(0, (previousValue, element) => previousValue + element);
  }

  double _calculateTotalExpenses() {
    return widget.transactions
        .where((transaction) => transaction.bills == 'chi')
        .map((transaction) => transaction.amount.toDouble())
        .fold<double>(0, (previousValue, element) => previousValue + element);
  }

  double _calculateProfit() {
    return _calculateTotalRevenue() - _calculateTotalExpenses();
  }



  BarChartData _barChartData(Map<int, double> profitByDayOfWeek) {
    return BarChartData(

      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 50,
            showTitles: true, // Make sure to set showTitles to true
            getTitlesWidget: (value, meta) => _getBottomTitles(value, meta),
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: true),
      gridData: FlGridData(show: false),
      barGroups: _getBarGroups(profitByDayOfWeek),
    );
  }

  List<BarChartGroupData> _getBarGroups(Map<int, double> data) {
    List<BarChartGroupData> barGroups = [];
    for (int i = 1; i <= 7; i++) {
      double profit = data[i + 1] ?? 0;
      barGroups.add(
        BarChartGroupData(
          x: i + 1,
          barRods: [
            BarChartRodData(
              toY: profit,
              width: 20,
              color: profit >= 0 ? Colors.green : Colors.red,
              // Color based on profit/loss
              gradient: LinearGradient(
                colors: profit >= 0
                    ? [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ]
                    : [
                  Colors.red.shade400,
                  Colors.red.shade800,
                ], // Gradient based on profit/loss
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
        ),
      );
    }
    return barGroups;
  }

  Map<int, double> _calculateProfitByDayOfWeek(List<Transactions> currentWeekTransactions) {
    Map<int, double> revenueByDayOfWeek = {};
    Map<int, double> expensesByDayOfWeek = {};

    for (var transaction in widget.transactions) {
      int dayOfWeek = transaction.date.weekday;
      double amount = transaction.amount.toDouble();

      if (transaction.bills == 'thu') {
        revenueByDayOfWeek.update(dayOfWeek, (value) => value + amount,
            ifAbsent: () => amount);
      } else if (transaction.bills == 'chi') {
        expensesByDayOfWeek.update(dayOfWeek, (value) => value + amount,
            ifAbsent: () => amount);
      }
    }

    Map<int, double> profitByDayOfWeek = {};
    for (int i = 1; i <= 7; i++) {
      double revenue = revenueByDayOfWeek[i - 1] ?? 0;
      double expenses = expensesByDayOfWeek[i - 1] ?? 0;
      profitByDayOfWeek[i] = revenue - expenses;
    }

    return profitByDayOfWeek;
  }

  Widget _buildStatisticItem(String label, double value, Color color) {
    final numberFormat = NumberFormat("#,##0");
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          numberFormat.format(value),
          style: TextStyle(color: color, fontSize: 18),
        ),
      ],
    );
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 13,
    );

    // Adjust the index to match day names (Sunday = 1, Monday = 2, etc.)
    // int dayIndex = value.toInt() % 7;
    // if (dayIndex == 0) dayIndex = 7;
    int dayIndex = value.toInt() + 2;

    String day = DateFormat.E().format(
        DateTime.fromMillisecondsSinceEpoch(0).add(Duration(days: dayIndex)));
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SideTitleWidget(
        axisSide: meta.axisSide,
        space: 16,
        child: Text(day, style: style),
      ),
    );
  }


  Future<void> _refreshData() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime lastDayOfWeek = firstDayOfWeek.add(const Duration(days: 6));

    // Check if any transaction is outside the current week
    bool needsRefresh = widget.transactions.any((transaction) =>
    transaction.date.isBefore(firstDayOfWeek) ||
        transaction.date.isAfter(lastDayOfWeek));

    if (needsRefresh) {
      // Clear existing data and fetch new data for the current week
      setState(() {
        _currentWeekTransactions = widget.transactions
            .where((transaction) =>
        !transaction.date.isBefore(firstDayOfWeek) &&
            !transaction.date.isAfter(lastDayOfWeek))
            .toList();
      });
    }
  }

// ... other methods ...
}


//import 'dart:core';
//
// import 'package:collection/collection.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:transaction_repository/transaction_repository.dart';
//
// class MyChart extends StatefulWidget {
//   final List<Transactions> transactions;
//
//   const MyChart({super.key, required this.transactions});
//
//   @override
//   State<MyChart> createState() => _MyChartState();
// }
//
// class _MyChartState extends State<MyChart> {
//   Map<int, Map<int, double>> _calculateProfitByMonthAndDayOfWeek() {
//     final transactionsByMonth = groupBy(widget.transactions, (transaction) =>
//         DateTime(transaction.date.year, transaction.date.month));
//
//     Map<int, Map<int, double>> profitByMonthAndDayOfWeek = {};
//
//     transactionsByMonth.forEach((month, transactions) {Map<int, double> profitByDayOfWeek = {};
//
//     final transactionsByDayOfWeek = groupBy(transactions,
//             (transaction) => transaction.date.weekday);
//
//     transactionsByDayOfWeek.forEach((dayOfWeek, transactions) {
//       double revenue = transactions
//           .where((transaction) => transaction.bills == 'thu')
//           .map((transaction) => transaction.amount.toDouble())
//           .sum;
//       double expenses = transactions
//           .where((transaction) => transaction.bills == 'chi')
//           .map((transaction) => transaction.amount.toDouble())
//           .sum;
//       profitByDayOfWeek[dayOfWeek] = revenue - expenses;
//     });
//
//     profitByMonthAndDayOfWeek[month.month] = profitByDayOfWeek;
//     });
//
//     return profitByMonthAndDayOfWeek;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Map<int, Map<int, double>> profitData =
//     _calculateProfitByMonthAndDayOfWeek();
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 80),
//           SizedBox(
//             height: 400,
//             child: BarChart(_barChartData(profitData)),
//           ),
//           FittedBox(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 10, bottom: 30),
//               child: Column(
//                 children: [
//                   _buildStatisticItem(
//                       'Tổng Thu: ', _calculateTotalRevenue(), Colors.green),
//                   const SizedBox(width: 12),
//                   _buildStatisticItem(
//                       'Tổng Chi: ', _calculateTotalExpenses(), Colors.red),
//                   const SizedBox(width: 12),
//                   _buildStatisticItem(
//                       'Lợi Nhuận: ', _calculateProfit(), Colors.blue),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   double _calculateTotalRevenue() {
//     return widget.transactions
//         .where((transaction) => transaction.bills == 'thu')
//         .map((transaction) => transaction.amount.toDouble())
//         .fold<double>(0, (previousValue, element) => previousValue + element);
//   }
//
//   double _calculateTotalExpenses() {
//     return widget.transactions
//         .where((transaction) => transaction.bills == 'chi')
//         .map((transaction) => transaction.amount.toDouble())
//         .fold<double>(0, (previousValue, element) => previousValue + element);
//   }
//
//   double _calculateProfit() {
//     return _calculateTotalRevenue() - _calculateTotalExpenses();
//   }
//
//   BarChartData _barChartData(Map<int, Map<int, double>> profitData) {
//     return BarChartData(
//       alignment: BarChartAlignment.spaceAround,
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: _getBottomTitles,
//             reservedSize: 50,
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             reservedSize: 50,
//           ),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles:const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//       ),
//       barGroups: _getBarGroups(profitData),
//       gridData: const FlGridData(show: false),
//     );
//   }
//
//   List<BarChartGroupData> _getBarGroups(
//       Map<int, Map<int, double>> profitByMonthAndDayOfWeek) {
//     List<BarChartGroupData> barGroups = [];
//
//     // Generate data for all 12 months
//     for (int month = 1; month <= 12; month++) {
//       double totalProfitForMonth = profitByMonthAndDayOfWeek[month]?.values
//           .fold<double>(0, (previousValue, element) => previousValue + element) ??
//           0;
//
//       barGroups.add(
//         BarChartGroupData(
//           x: month,
//           barRods: [
//             BarChartRodData(
//               toY: totalProfitForMonth,
//               width: 15,
//               color: totalProfitForMonth >= 0 ? Colors.green : Colors.red,
//               gradient: LinearGradient(
//                 colors: totalProfitForMonth >= 0
//                     ? [
//                   Theme.of(context).colorScheme.tertiary,
//                   Theme.of(context).colorScheme.secondary,
//                   Theme.of(context).colorScheme.primary,
//                 ]
//                     : [
//                   Colors.red.shade400,
//                   Colors.red.shade800,
//                 ],
//                 begin: Alignment.bottomCenter,
//                 end: Alignment.topCenter,
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return barGroups;
//   }
//
//   Widget _getBottomTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.grey,
//       fontWeight: FontWeight.bold,
//       fontSize: 13,
//     );
//
//     int monthIndex = value.toInt();
//     String month = DateFormat.MMM().format(DateTime(0, monthIndex));
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 16,
//       child: Text(month, style: style),
//     );
//   }
//
//   Widget _buildStatisticItem(String label, double value, Color color) {
//     final numberFormat = NumberFormat("#,##0");
//     return Row(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           numberFormat.format(value),
//           style: TextStyle(color: color, fontSize: 18),
//         ),
//       ],
//     );
//   }
// }



//import 'dart:core';
//
// import 'package:collection/collection.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:transaction_repository/transaction_repository.dart';
//
// class MyChart extends StatefulWidget {
//   final List<Transactions> transactions;
//   final String? period;
//
//   const MyChart({super.key, required this.transactions, required this.period});
//
//   @override
//   State<MyChart> createState() => _MyChartState();
// }
//
// class _MyChartState extends State<MyChart> {
//   // Map<int, double> _calculateProfitData() {
//   //   // Always return monthly data
//   //   return _calculateProfitByMonth();
//   // }
//
//   Map<int, double> _calculateProfitByMonth(
//       List<Transactions> currentWeekTransactions) {
//     Map<int, double> profitByMonth = {};
//
//     // Initialize profit for all 12 months to 0
//     for (int month = 1; month <= 12; month++) {
//       profitByMonth[month - 2] = 0;
//     }
//
//     // Calculate profit for months with data
//     final transactionsByMonth = groupBy(
//         widget.transactions,
//         (transaction) =>
//             DateTime(transaction.date.year, transaction.date.month));
//     transactionsByMonth.forEach((month, transactions) {
//       double revenue = transactions
//           .where((transaction) => transaction.bills == 'thu')
//           .map((transaction) => transaction.amount.toDouble())
//           .sum;
//       double expenses = transactions
//           .where((transaction) => transaction.bills == 'chi')
//           .map((transaction) => transaction.amount.toDouble())
//           .sum;
//       profitByMonth[month.month] = revenue - expenses;
//     });
//
//     return profitByMonth;
//   }
//
//   Map<int, double> _calculateProfitByDayOfWeek(
//       List<Transactions> currentWeekTransactions) {
//     Map<int, double> revenueByDayOfWeek = {};
//     Map<int, double> expensesByDayOfWeek = {};
//
//     for (var transaction in widget.transactions) {
//       int dayOfWeek = transaction.date.weekday;
//       double amount = transaction.amount.toDouble();
//
//       if (transaction.bills == 'thu') {
//         revenueByDayOfWeek.update(dayOfWeek, (value) => value + amount,
//             ifAbsent: () => amount);
//       } else if (transaction.bills == 'chi') {
//         expensesByDayOfWeek.update(dayOfWeek, (value) => value + amount,
//             ifAbsent: () => amount);
//       }
//     }
//
//     Map<int, double> profitByDayOfWeek = {};
//     for (int i = 1; i <= 7; i++) {
//       double revenue = revenueByDayOfWeek[i - 1] ?? 0;
//       double expenses = expensesByDayOfWeek[i - 1] ?? 0;
//       profitByDayOfWeek[i] = revenue - expenses;
//     }
//
//     return profitByDayOfWeek;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Map<int, double> profitData = _calculateProfitData();
//     Map<int, Map<int, double>> nestedProfitData = {};
//     profitData.forEach((month, profit) {
//       nestedProfitData[month] = {1: profit}; // Assuming dayOfWeek is always 1
//     });
//     return SingleChildScrollView(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 80),
//           SizedBox(
//             height: 400,
//             child: BarChart(_barChartData(nestedProfitData)),
//           ),
//           FittedBox(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 10, bottom: 30),
//               child: Column(
//                 children: [
//                   _buildStatisticItem(
//                       'Tổng Thu: ', _calculateTotalRevenue(), Colors.green),
//                   const SizedBox(width: 12),
//                   _buildStatisticItem(
//                       'Tổng Chi: ', _calculateTotalExpenses(), Colors.red),
//                   const SizedBox(width: 12),
//                   _buildStatisticItem(
//                       'Lợi Nhuận: ', _calculateProfit(), Colors.blue),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   double _calculateTotalRevenue() {
//     return widget.transactions
//         .where((transaction) => transaction.bills == 'thu')
//         .map((transaction) => transaction.amount.toDouble())
//         .fold<double>(0, (previousValue, element) => previousValue + element);
//   }
//
//   double _calculateTotalExpenses() {
//     return widget.transactions
//         .where((transaction) => transaction.bills == 'chi')
//         .map((transaction) => transaction.amount.toDouble())
//         .fold<double>(0, (previousValue, element) => previousValue + element);
//   }
//
//   double _calculateProfit() {
//     return _calculateTotalRevenue() - _calculateTotalExpenses();
//   }
//
//   BarChartData _barChartData(Map<int, Map<int, double>> profitData) {
//     return BarChartData(
//       alignment: BarChartAlignment.spaceAround,
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: _getBottomTitles,
//             reservedSize: 50,
//           ),
//         ),
//         leftTitles: const AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: false,
//             reservedSize: 50,
//           ),
//         ),
//         topTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//         rightTitles: const AxisTitles(
//           sideTitles: SideTitles(showTitles: false),
//         ),
//       ),
//       borderData: FlBorderData(
//         show: true,
//         border: const Border(bottom: BorderSide(color: Colors.black)),
//       ),
//       barGroups: _getBarGroups(profitData),
//       gridData: const FlGridData(show: false),
//     );
//   }
//
//   List<BarChartGroupData> _getBarGroups(
//       Map<int, Map<int, double>> profitByMonthAndDayOfWeek) {
//     List<BarChartGroupData> barGroups = [];
//
//     profitByMonthAndDayOfWeek.forEach((month, profitByDayOfWeek) {
//       List<BarChartRodData> rods = [];
//
//       for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
//         double profit = profitByDayOfWeek[dayOfWeek] ?? 0;
//         rods.add(
//           BarChartRodData(
//             toY: profit,
//             width: 15,
//             color: profit >= 0 ? Colors.green : Colors.red,
//             gradient: LinearGradient(
//               colors: profit >= 0
//                   ? [
//                       Theme.of(context).colorScheme.secondary,
//                       Theme.of(context).colorScheme.tertiary,
//                       Theme.of(context).colorScheme.primary,
//                     ]
//                   : [
//                       Colors.red.shade400,
//                       Colors.red.shade800,
//                     ],
//               begin: Alignment.bottomCenter,
//               end: Alignment.topCenter,
//             ),
//           ),
//         );
//       }
//
//       barGroups.add(
//         BarChartGroupData(
//           x: month,
//           barsSpace: 4,
//           barRods: rods,
//         ),
//       );
//     });
//
//     return barGroups;
//   }
//
//   Map<int, double> _calculateProfitData() {
//     if (widget.period == 'week') {
//       return _calculateProfitByDayOfWeek(widget.transactions);
//     } else {
//       return _calculateProfitByMonth(widget.transactions);
//     }
//   }
//
//   Widget _getBottomTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.grey,
//       fontWeight: FontWeight.bold,
//       fontSize: 13,
//     );
//
//     Widget text;
//     if (widget.period == 'week') {
//       // Display day of the week
//       int dayIndex = value.toInt() + 3;
//       String day = DateFormat.E().format(
//           DateTime.fromMillisecondsSinceEpoch(0).add(Duration(days: dayIndex)));
//       text = Text(day, style: style);
//     } else {
//       // Display month name
//       int monthIndex = value.toInt() + 2;
//       String month = DateFormat.MMM().format(DateTime(0, monthIndex));
//       text = Text(month, style: style);
//     }
//
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       space: 16,
//       child: text,
//     );
//   }
//
//   Widget _buildStatisticItem(String label, double value, Color color) {
//     final numberFormat = NumberFormat("#,##0");
//     return Row(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           numberFormat.format(value),
//           style: TextStyle(color: color, fontSize: 18),
//         ),
//       ],
//     );
//   }
// }