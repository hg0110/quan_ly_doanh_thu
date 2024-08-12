import 'package:flutter/material.dart';
import 'package:quan_ly_doanh_thu/pages/stats/chart.dart';
import 'package:transaction_repository/transaction_repository.dart';

class StatScreen extends StatefulWidget {
  final String title;
  const StatScreen({super.key, required this.title});

  @override
  State<StatScreen> createState() => _StatScreenState();
}

class _StatScreenState extends State<StatScreen> {
  String selectedPeriod = 'week';
  final _transactionRepository = FirebaseTransactionRepo();
  List<Transactions> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async{
    if (mounted) { // Check if the widget isstill mounted
      transactions = await _transactionRepository.fetchFutureTransactions(selectedPeriod);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedPeriod,
            items: const [
              DropdownMenuItem(value: 'week', child: Text('Tuần')),
              DropdownMenuItem(value: 'month', child: Text('Tháng')),
              DropdownMenuItem(value: 'year', child: Text('Năm')),
            ],
            onChanged: (value) {
              setState(() {
                selectedPeriod = value!;
                _fetchData();
              });
            },
          ),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : MyChart(
              period: selectedPeriod,
              transactions: transactions,
            ),
          ),
        ],
      ),
    );
  }
}