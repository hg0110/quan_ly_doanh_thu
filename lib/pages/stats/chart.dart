import 'dart:core';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_repository/transaction_repository.dart';

class MyChart extends StatefulWidget {
  final List<Transactions> transactions;
  final String period;
  const MyChart({
    super.key,
    required this.period,
    required this.transactions,
  });

  @override
  State<MyChart> createState() => _MyChartState();
}

class _MyChartState extends State<MyChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 400,
          child: BarChart(_barChartData()),
        ),
        FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatisticItem(
                    'Tổng Thu', _calculateTotalRevenue(), Colors.green),
                const SizedBox(width: 12),
                _buildStatisticItem(
                    'Tổng Chi', _calculateTotalExpenses(), Colors.red),
                const SizedBox(width: 12),
                _buildStatisticItem('Lợi Nhuận', _calculateProfit(), Colors.blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateTotalRevenue() {
    return widget.transactions
        .where((transaction) => transaction.isRevenue)
        .map((transaction) => transaction.amount.toDouble())
        .fold<double>(0, (previousValue, element) => previousValue + element);
  }

  double _calculateTotalExpenses() {
    return widget.transactions
        .where((transaction) => !transaction.isRevenue)
        .map((transaction) => transaction.amount.toDouble())
        .fold<double>(0, (previousValue, element) => previousValue + element);
  }

  double _calculateProfit() {
    return _calculateTotalRevenue() - _calculateTotalExpenses();
  }

  BarChartData _barChartData() {
    Map<int, double> dataByPeriod = _calculateDataByPeriod();
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) =>
                _getBottomTitles(value, meta, widget.period),
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
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
      borderData: FlBorderData(show: false),
      gridData: FlGridData(show: false),
      barGroups: _getBarGroups(dataByPeriod),
    );
  }

  List<BarChartGroupData> _getBarGroups(Map<int, double> data) {
    List<BarChartGroupData> barGroups = [];
    data.forEach((period, value) {
      barGroups.add(
        BarChartGroupData(
          x: period,
          barRods: [
            BarChartRodData(
              toY: value,
              width: 20,
              color: value >= 0 ? Colors.green : Colors.red,
              gradient: LinearGradient(
                colors: [
                  Colors.green.shade400,
                  Colors.green.shade800,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
        ),
      );
    });
    return barGroups;
  }

  Map<int, double> _calculateDataByPeriod() {
    if (widget.period == 'week') {
      return _calculateDataByWeek();
    } else if (widget.period == 'month') {
      return _calculateDataByMonth();
    } else if (widget.period == 'year') {
      return _calculateDataByYear();
    } else {
      return {};}
  }

  Map<int, double> _calculateDataByWeek() {
    Map<int, double> dataByWeek = {};
    for (var transaction in widget.transactions) {
      int week = weekOfYear(transaction.date);
      double amount = transaction.isRevenue
          ? transaction.amount.toDouble()
          : -transaction.amount.toDouble();
      dataByWeek.update(week, (value) => value + amount, ifAbsent: () => amount);
    }
    return dataByWeek;
  }

  Map<int, double> _calculateDataByMonth() {
    Map<int, double> dataByMonth = {};
    for (var transaction in widget.transactions) {
      int month = transaction.date.month;
      double amount = transaction.isRevenue
          ? transaction.amount.toDouble()
          : -transaction.amount.toDouble();
      dataByMonth.update(month, (value) => value + amount,
          ifAbsent: () => amount);
    }
    return dataByMonth;
  }

  Map<int, double> _calculateDataByYear() {
    Map<int, double> dataByYear = {};
    for (var transaction in widget.transactions) {
      int year = transaction.date.year;
      double amount = transaction.isRevenue
          ? transaction.amount.toDouble()
          : -transaction.amount.toDouble();
      dataByYear.update(year, (value) => value + amount,
          ifAbsent: () => amount);
    }
    return dataByYear;
  }

  int weekOfYear(DateTime date) {
    int dayOfYear = int.parse(DateFormat('D').format(date));
    int woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = weekOfYear(date.subtract(const Duration(days: 7)));
    } else if (woy > 52) {
      woy = 1;
    }
    return woy;
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

  Widget _getBottomTitles(double value, TitleMeta meta, String period) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (period) {
      case 'week':
        text = Text(
          'W${value.toInt()}',
          style: style,
        );
        break;
      case 'month':
        text = Text(
          'M${value.toInt()}',
          style: style,
        );
        break;
      case 'year':
        text = Text(
          value.toInt().toString(),
          style: style,
        );
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}

