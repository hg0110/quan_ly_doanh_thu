import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MyDayChart extends StatefulWidget {
  final List<double> revenueData; // Revenue data for different periods
  final List<double> expensesData; // Expenses data for different periods
  // final double totalRevenue;
  // final double totalExpenses;
  final Transactions transactions;
  final String period; // 'day', 'month', or 'year'
  const MyDayChart(
      {super.key,
      required this.period,
      required this.revenueData,
      required this.expensesData,
      required this.transactions});

  @override
  State<MyDayChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyDayChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 400,
          child: BarChart(
            mainBarData(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatisticItem(
                  'Tổng Thu', calculateTotal(widget.revenueData), Colors.green),
              _buildStatisticItem(
                  'Tổng Chi', calculateTotal(widget.expensesData), Colors.red),
              _buildStatisticItem(
                  'Lợi Nhuận',
                  calculateTotal(widget.revenueData) -
                      calculateTotal(widget.expensesData),
                  Colors.blue),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticItem(String label, double value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(color: color, fontSize: 18),
        ),
      ],
    );
  }

  double calculateTotal(List<double> data) {
    return data.fold<double>(
        0, (previousValue, element) => previousValue + element);
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
          toY: y.isFinite ? y : 0,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.tertiary,
            ],
            transform: const GradientRotation(pi / 40),
          ),
          width: 20,
          backDrawRodData: BackgroundBarChartRodData(
              show: true, toY: 5, color: Colors.grey.shade300))
    ]);
  }

  List<BarChartGroupData> showingGroups() {
    List<BarChartGroupData> barGroups = [];

    if (widget.period == 'day') {
      // Generate data for day
      Map<DateTime, double> dailyRevenue =
          calculateDailyRevenue(widget.transactions as List<Transactions>);
      List<DateTime> dates = dailyRevenue.keys.toList();
      for (int i = 0; i < dates.length; i++) {
        barGroups.add(makeGroupData(i, dailyRevenue[dates[i]]!.toDouble()));
      }
    } else if (widget.period == 'hour') {
      // Generate data for hour
      Map<int, double> hourlyRevenue =
          calculateHourlyRevenue(widget.transactions as List<Transactions>);
      for (int i = 0; i < 24; i++) {
        barGroups.add(makeGroupData(i, hourlyRevenue[i] ?? 0));
      }
    } else if (widget.period == 'weekday') {
      // Generate data for weekdays
      List<double> weekdayRevenue =
          calculateWeekdayRevenue(widget.transactions as List<Transactions>);
      for (int i = 0; i < 7; i++) {
        barGroups.add(makeGroupData(i, weekdayRevenue[i]));
      }
    }
    return barGroups;
  }

  Map<DateTime, double> calculateDailyRevenue(List<Transactions> transactions) {
    // Assuming your transaction object has a dateTime field
    // List<Transactions> transactions = ; // Your transaction data
    // Group transactions by day and calculate total revenue
    Map<DateTime, double> dailyRevenue = {};
    for (var transaction in transactions) {
      DateTime date = DateTime(
          transaction.date.year, transaction.date.month, transaction.date.day);
      if (dailyRevenue.containsKey(date)) {
        dailyRevenue[date] = dailyRevenue[date]! + transaction.amount;
      } else {
        dailyRevenue[date] = transaction.amount as double;
      }
    }

    return dailyRevenue;
  }

  Map<int, double> calculateHourlyRevenue(List<Transactions> transactions) {
    // Assuming your transaction object has a dateTime field
    // List<Transactions> transactions = ...; // Your transaction data

    //Group transactions by hour and calculate total revenue
    Map<int, double> hourlyRevenue = {};
    for (var transaction in transactions) {
      int hour = transaction.date.hour;
      if (hourlyRevenue.containsKey(hour)) {
        hourlyRevenue[hour] = hourlyRevenue[hour]! + transaction.amount;
      } else {
        hourlyRevenue[hour] = transaction.amount as double;
      }
    }

    return hourlyRevenue;
  }

  List<double> calculateWeekdayRevenue(List<Transactions> transactions) {
    // Assuming your transaction object has a dateTime field
    // List<Transactions> transactions = ...; // Your transaction data

    // Group transactions by weekday and calculate total revenue
    Map<int, List<Transactions>> transactionsByWeekday = {};
    for (var transaction in transactions) {
      int weekday = transaction.date.weekday; // 1 (Monday) to 7 (Sunday)
      if (transactionsByWeekday.containsKey(weekday)) {
        transactionsByWeekday[weekday]!.add(transaction);
      } else {
        transactionsByWeekday[weekday] = [transaction];
      }
    }

    List<double> weekdayRevenue = List.filled(7, 0);
    for (int i = 1; i <= 7; i++) {
      double total = transactionsByWeekday[i]?.fold<double>(
              0, (sum, transaction) => sum + transaction.amount) ??
          0;
      weekdayRevenue[i - 1] = total;
    }

    return weekdayRevenue;
  }

// Update getTiles to display labels based on period
  Widget getTiles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (widget.period == 'day') {
      // Display date for daily data
      DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
      text = '${date.day}/${date.month}';
    } else if (widget.period == 'hour') {
      // Display hour for hourly data
      text = '${value.toInt()}:00';
    } else if (widget.period == 'weekday') {
      // Display weekday name
      switch (value.toInt()) {
        case 0:
          text = 'Mon';
          break;
        case 1:
          text = 'Tue';
          break;
        case 2:
          text = 'Wed';
          break;
        case 3:
          text = 'Thu';
          break;
        case 4:
          text = 'Fri';
          break;
        case 5:
          text = 'Sat';
          break;
        case 6:
          text = 'Sun';
          break;
        default:
          text = '';
          break;
      }
    } else {
      text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(text, style: style),
    );
  }

// Uncomment bottomTitles in mainBarData
  BarChartData mainBarData() {
    return BarChartData(
        // ... other configurations
        // bottomTitles: AxisTitles(
        //     sideTitles: SideTitles(
        //       showTitles: true,
        //       reservedSize: 38,
        //       getTitlesWidget: getTiles,
        //     )),
        // ... other configurations
        );
  }

  // Widget getTiles(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     color: Colors.grey,
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //   );
  //   Widget text;
  //   int intValue = value.toInt();
  //   if (intValue.isEven) {
  //     text = Text('Thu ${intValue ~/ 2}', style: style);
  //   } else {
  //     text = Text('Chi ${(intValue - 1) ~/ 2}', style: style);
  //   }
  //   // switch (value.toInt()) {
  //   //   case 0:
  //   //     text = const Text('Thu', style: style);
  //   //     break;
  //   //   case 1:
  //   //     text = const Text('Chi', style: style);
  //   //     break;
  //   //   // case 2:
  //   //   //   text = const Text('03', style: style);
  //   //   //   break;
  //   //   // case 3:
  //   //   //   text = const Text('04', style: style);
  //   //   //   break;
  //   //   // case 4:
  //   //   //   text = const Text('05', style: style);
  //   //   //   break;
  //   //   // case 5:
  //   //   //   text = const Text('06', style: style);
  //   //   //   break;
  //   //   // case 6:
  //   //   //   text = const Text('07', style: style);
  //   //   //   break;
  //   //   // case 7:
  //   //   //   text = const Text('08', style: style);
  //   //   //   break;
  //   //   default:
  //   //     text = const Text('', style: style);
  //   //     break;
  //   // }
  //   return SideTitleWidget(
  //     axisSide: meta.axisSide,
  //     space: 16,
  //     child: text,
  //   );
  // }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '';
    } else if (value == 2) {
      text = '2K';
    } else if (value == 4) {
      text = '4K';
    } else if (value == 6) {
      text = '6K';
    } else if (value == 8) {
      text = '8K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }
}

// Map<int, double> _calculateRevenueByDayOfWeek() {
//   Map<int, double> revenueByDayOfWeek = {};
//   for (var transaction in widget.transactions) {
//     int dayOfWeek = transaction.date.weekday; // 1 (Monday) to 7 (Sunday)
//     if (revenueByDayOfWeek.containsKey(dayOfWeek)) {
//       revenueByDayOfWeek[dayOfWeek] =
//           revenueByDayOfWeek[dayOfWeek]! + transaction.amount;
//     } else {
//       revenueByDayOfWeek[dayOfWeek] = transaction.amount.toDouble();
//     }
//   }
//   return revenueByDayOfWeek;
// }
//
// Widget _buildStatisticItem(String label, double value, Color color) {
//   return Column(
//     children: [
//       Text(
//         label,
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ),
//       const SizedBox(height: 4),
//       Text(
//         '\$${value.toStringAsFixed(2)}',
//         style: TextStyle(color: color, fontSize: 18),
//       ),
//     ],
//   );
// }
//
// double calculateTotal(List<double> data) {
//   return data.fold<double>(
//       0, (previousValue, element) => previousValue + element);
// }
//
// // BarChartGroupData makeGroupData(int x, double y) {
// //   return BarChartGroupData(x: x, barRods: [
// //     BarChartRodData(
// //         toY: y.isFinite ? y : 0,
// //         gradient: LinearGradient(
// //           colors: [
// //             Theme.of(context).colorScheme.primary,
// //             Theme.of(context).colorScheme.secondary,
// //             Theme.of(context).colorScheme.tertiary,
// //           ],
// //           transform: const GradientRotation(pi / 40),
// //         ),
// //         width: 20,
// //         backDrawRodData: BackgroundBarChartRodData(
// //             show: true, toY: 5, color: Colors.grey.shade300))
// //   ]);
// // }
// //
// // List<BarChartGroupData> showingGroups() {
// //   List<BarChartGroupData> barGroups = [];
// //   if (widget.period == 'day') {
// //     // Generate data for day
// //     int dataLength =
// //         min(widget.revenueData.length, widget.expensesData.length);
// //     for (int i = 0; i < dataLength; i++) {
// //       double totalRevenueForDay =
// //           widget.revenueData[i] - widget.expensesData[i];
// //       barGroups.add(makeGroupData(i, totalRevenueForDay));
// //     }
// //   } else if (widget.period == 'month') {
// //     // Generate data for month
// //     // Example: group data by month and calculate monthly totals
// //     // You'll need to adapt this based on your data structure
// //     for (int i = 1; i <= 12; i++) {
// //       double monthlyRevenue = calculateMonthlyTotal(widget.revenueData, i);
// //       double monthlyExpenses = calculateMonthlyTotal(widget.expensesData, i);
// //       // Calculate total revenue for the month
// //       double totalRevenueForMonth = monthlyRevenue - monthlyExpenses;
// //       barGroups.add(makeGroupData(i, totalRevenueForMonth));
// //     }
// //   } else if (widget.period == 'year') {
// //     // Group data by year and calculate yearly totals
// //     // Assuming you have data for multiple years
// //     int numYears = 3;
// //     for (int i = 0; i < numYears; i++) {
// //       double yearlyRevenue = calculateYearlyTotal(widget.revenueData, i);
// //       double yearlyExpenses = calculateYearlyTotal(widget.expensesData, i);
// //       // Calculate total revenue for the year
// //       double totalRevenueForYear = yearlyRevenue - yearlyExpenses;
// //       barGroups.add(makeGroupData(i, totalRevenueForYear));
// //     }
// //   }
// //   return barGroups;
// // }
//
//
// double calculateMaxY(double defaultMaxY) {
//   double maxY = defaultMaxY;
//   if (widget.revenueData.isNotEmpty) {
//     maxY = widget.revenueData.reduce(max);
//   }
//   if (widget.expensesData.isNotEmpty) {
//     maxY = max(maxY, widget.expensesData.reduce(max));
//   }
//   return maxY;
// }
//
// double calculateMonthlyTotal(List<double> data, int month) {
//   // Implement logic to calculate total for the given month
//   // This will depend on how your data is structured
//   // Example: If your data is a simple list where each index represents a month
//   if (month >= 0 && month < data.length) {
//     return data[month];
//   } else {
//     return 0;
//   }
// }
//
// double calculateYearlyTotal(List<double> data, int year) {
//   if (year >= 0 && year < data.length) {
//     return data.reduce(max); // Use max function directly with reduce
//   } else {
//     return 0;
//   }
// }
//
// // List<BarChartGroupData> showingGroups() => List.generate(8, (i) {
// //   switch (i) {
// //     case 0:
// //       return makeGroupData(0, widget.totalRevenue.isFinite ? widget.totalRevenue :0);
// //     case 1:
// //       return makeGroupData(1, widget.totalExpenses.isFinite ? widget.totalExpenses :0);
// //     // case 2:
// //     //   return makeGroupData(2, 2);
// //     // case 3:
// //     //   return makeGroupData(3, 4.5);
// //     // case 4:
// //     //   return makeGroupData(4, 3.8);
// //     // case 5:
// //     //   return makeGroupData(5, 1.5);
// //     // case 6:
// //     //   return makeGroupData(6, 4);
// //     // case 7:
// //     //   return makeGroupData(7, 3.8);
// //     default:
// //       return makeGroupData(i, 0);
// //       // return throw Error();
// //   }
// // });
//
//
// BarChartData _barChartData(Map<int, double> revenueByDayOfWeek) {
//   return BarChartData(
//     titlesData: FlTitlesData(
//       show: true,
//       bottomTitles: AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           getTitlesWidget: _getBottomTitles,
//         ),
//       ),
//       leftTitles: const AxisTitles(
//         sideTitles: SideTitles(
//           showTitles: true,
//           reservedSize: 30,
//         ),),
//       topTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//       rightTitles: const AxisTitles(
//         sideTitles: SideTitles(showTitles: false),
//       ),
//     ),
//     borderData: FlBorderData(show: false),
//     gridData: const FlGridData(show: false),
//     barGroups: _getBarGroups(revenueByDayOfWeek),
//   );
// }
//
// List<BarChartGroupData> _getBarGroups(Map<int, double> revenueByDayOfWeek) {
//   List<BarChartGroupData> barGroups = [];
//   revenueByDayOfWeek.forEach((dayOfWeek, revenue) {
//     barGroups.add(
//       BarChartGroupData(
//         x: dayOfWeek,
//         barRods: [
//           BarChartRodData(
//             toY: revenue,
//             width: 20,
//             color: Colors.blue,
//           ),
//         ],
//       ),
//     );
//   });
//   return barGroups;
// }
//
// Widget _getBottomTitles(double value, TitleMeta meta) {
//   const style = TextStyle(
//     color: Colors.grey,
//     fontWeight: FontWeight.bold,
//     fontSize: 14,
//   );
//   Widget text;
//   switch (value.toInt()) {
//     case 1:
//       text = const Text('Mon', style: style);
//       break;
//     case 2:
//       text = const Text('Tue', style: style);
//       break;
//     case 3:
//       text = const Text('Wed', style: style);
//       break;
//     case 4:
//       text = const Text('Thu', style: style);
//       break;
//     case 5:
//       text = const Text('Fri', style: style);
//       break;
//     case 6:
//       text = const Text('Sat', style: style);
//       break;
//     case 7:
//       text = const Text('Sun', style: style);
//       break;
//     default:
//       text = const Text('', style: style);
//       break;
//   }
//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     space: 16, //margin top
//     child: text,);
// }
//
// // BarChartData mainBarData() {
// //   return BarChartData(
// //     titlesData: FlTitlesData(
// //       show: true,
// //       rightTitles:
// //           const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
// //       // bottomTitles: AxisTitles(
// //       //     sideTitles: SideTitles(
// //       //   showTitles: true,
// //       //   reservedSize: 38,
// //       //   getTitlesWidget: getTiles,
// //       // )),
// //       leftTitles: AxisTitles(
// //         sideTitles: SideTitles(
// //           showTitles: true,
// //           reservedSize: 38,
// //           getTitlesWidget: leftTitles,
// //         ),
// //       ),
// //     ),
// //     borderData: FlBorderData(show: false),
// //     gridData: const FlGridData(show: false),
// //     barGroups: showingGroups(),
// //   );
// // }
//
// // Widget getTiles(double value, TitleMeta meta) {
// //   const style = TextStyle(
// //     color: Colors.grey,
// //     fontWeight: FontWeight.bold,
// //     fontSize: 14,
// //   );
// //   Widget text;
// //   int intValue = value.toInt();
// //   if (intValue.isEven) {
// //     text = Text('Thu ${intValue ~/ 2}', style: style);
// //   } else {
// //     text = Text('Chi ${(intValue - 1) ~/ 2}', style: style);
// //   }
// //   // switch (value.toInt()) {
// //   //   case 0:
// //   //     text = const Text('Thu', style: style);
// //   //     break;
// //   //   case 1:
// //   //     text = const Text('Chi', style: style);
// //   //     break;
// //   //   // case 2:
// //   //   //   text = const Text('03', style: style);
// //   //   //   break;
// //   //   // case 3:
// //   //   //   text = const Text('04', style: style);
// //   //   //   break;
// //   //   // case 4:
// //   //   //   text = const Text('05', style: style);
// //   //   //   break;
// //   //   // case 5:
// //   //   //   text = const Text('06', style: style);
// //   //   //   break;
// //   //   // case 6:
// //   //   //   text = const Text('07', style: style);
// //   //   //   break;
// //   //   // case 7:
// //   //   //   text = const Text('08', style: style);
// //   //   //   break;
// //   //   default:
// //   //     text = const Text('', style: style);
// //   //     break;
// //   // }
// //   return SideTitleWidget(
// //     axisSide: meta.axisSide,
// //     space: 16,
// //     child: text,
// //   );
// // }
//
// Widget leftTitles(double value, TitleMeta meta) {
//   const style = TextStyle(
//     color: Colors.grey,
//     fontWeight: FontWeight.bold,
//     fontSize: 14,
//   );
//   String text;
//   if (value == 0) {
//     text = '';
//   } else if (value == 2) {
//     text = '2K';
//   } else if (value == 4) {
//     text = '4K';
//   } else if (value == 6) {
//     text = '6K';
//   } else if (value == 8) {
//     text = '8K';
//   } else {
//     return Container();
//   }
//   return SideTitleWidget(
//     axisSide: meta.axisSide,
//     space: 0,
//     child: Text(text, style: style),