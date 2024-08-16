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
  String? selectedPeriod;
  final _transactionRepository = FirebaseTransactionRepo();
  List<Transactions> transactions = [];

  @override
  void initState() {
    super.initState();
    // _fetchData();
  }

  Future<void> _fetchData() async {
    if (mounted) {
      transactions =
          await _transactionRepository.fetchTransactions(selectedPeriod!);
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DropdownButton<String>(
            hint: selectedPeriod == null
                ? const Text('Hãy chọn')
                : Text(
              selectedPeriod!,
              style: const TextStyle(
                  color: Colors.green, fontSize: 13),
            ),
            // isExpanded: true,
            iconSize: 40.0,
            style: const TextStyle(
                color: Colors.green, fontSize: 16),
            value: selectedPeriod,
            items: const [
              DropdownMenuItem(value: 'week', child: Text('Tuần')),
              DropdownMenuItem(value: 'month', child: Text('Tháng')),
            ],
            onChanged: (value) {
              setState(() {
                selectedPeriod = value;
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
