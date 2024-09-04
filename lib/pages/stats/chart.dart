import 'dart:async';
import 'dart:core';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_repository/transaction_repository.dart';

class Chart extends StatefulWidget {
  final List<Transactions> transactions;
  final String? period;const Chart({super.key, required this.transactions, this.period});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  late DateTime _currentWeekStart = _getStartOfWeek(DateTime.now());



  Map<int, double> _calculateProfitByMonth(List<Transactions> transactions) {
    Map<int, double> profitByMonth = {};
    for (int month = 1; month <= 12; month++) {
      profitByMonth[month] = 0;
    }

    final transactionsByMonth = groupBy(
        widget.transactions,
            (transaction) =>
            DateTime(transaction.date.year, transaction.date.month));

    transactionsByMonth.forEach((month, transactions) {
      double revenue = transactions
          .where((transaction) => transaction.bills == 'thu')
          .map((transaction) => transaction.amount.toDouble())
          .sum;
      double expenses = transactions
          .where((transaction) => transaction.bills == 'chi')
          .map((transaction) => transaction.amount.toDouble())
          .sum;
      profitByMonth[month.month] = revenue - expenses;
    });

    return profitByMonth;
  }

  Map<int, double> _calculateProfitByDayOfWeek(
      List<Transactions> transactions) {
    Map<int, double> profitByDayOfWeek = {};

    for (int day = 0; day < 7; day++) {
      profitByDayOfWeek[day] = 0;
    }

    for (var transaction in widget.transactions.where((t) =>
    t.date.isAfter(_currentWeekStart) &&
        t.date.isBefore(_currentWeekStart.add(const Duration(days: 7))))) {
      int dayOfWeek = transaction.date.weekday - 1;
      double amount = transaction.amount.toDouble();

      if (transaction.bills == 'thu') {
        profitByDayOfWeek.update(dayOfWeek, (value) => value + amount,
            ifAbsent: () => amount);
      } else if (transaction.bills == 'chi') {
        profitByDayOfWeek.update(dayOfWeek, (value) => value - amount,
            ifAbsent: () => -amount);
      }
    }

    return profitByDayOfWeek;
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(days: 7), (timer) {
      _updateCurrentWeek();
    });
  }

  void _updateCurrentWeek() {
    setState(() {
      _currentWeekStart = _getStartOfWeek(DateTime.now());
    });
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.period == 'week') {
      return _buildChart(
          _calculateProfitByDayOfWeek(widget.transactions), 'week');
    } else {
      return _buildChart(_calculateProfitByMonth(widget.transactions), 'month');
    }
  }

  Widget _buildChart(Map<int, double> profitData, String period) {
    return Column(
      children: [
        SizedBox(
          height: 450,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) =>
                        _getBottomTitles(value, meta, period),
                    reservedSize: 50,
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 50,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(bottom: BorderSide(color: Colors.black)),
              ),
              barGroups: _getBarGroups(profitData, period),
              gridData: const FlGridData(show: false),
            ),
          ),
        ),
        // const SizedBox(height: 20),
        // if (period == 'month')
        //   FittedBox(
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 10, bottom: 30),
        //       child: Column(
        //         children: [
        //           _buildStatisticItem(
        //               'Tổng Thu: ', _calculateTotalRevenue(), Colors.green),
        //           const SizedBox(width: 12),
        //           _buildStatisticItem(
        //               'Tổng Chi: ', _calculateTotalExpenses(), Colors.red),
        //           const SizedBox(width: 12),
        //           _buildStatisticItem(
        //               'Lợi Nhuận: ', _calculateProfit(), Colors.blue),
        //         ],
        //       ),
        //     ),
        //   ),
      ],
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

  List<BarChartGroupData> _getBarGroups(
      Map<int, double> profitData, String period) {
    List<BarChartGroupData> barGroups = [];

    profitData.forEach((index, profit) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: profit,
              width: 20,
              color: profit >= 0 ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    });

    return barGroups;
  }

  Widget _getBottomTitles(double value, TitleMeta meta, String period) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    Widget text;
    if (period == 'week') {
      switch (value.toInt()) {
        case 0:
          text = const Text('T2', style: style);
          break;
        case 1:
          text = const Text('T3', style: style);
          break;
        case 2:
          text = const Text('T4', style: style);
          break;
        case 3:
          text = const Text('T5', style: style);
          break;
        case 4:
          text = const Text('T6', style: style);
          break;
        case 5:
          text = const Text('T7', style: style);
          break;
        case 6:
          text = const Text('CN', style: style);
          break;
        default:
          text = const Text('', style: style);
          break;
      }
    } else {
      int monthIndex = value.toInt();
      String month = DateFormat.MMM().format(DateTime(0, monthIndex));
      text = Text(month, style: style);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
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
}