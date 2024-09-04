import 'package:flutter/material.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTimeRange?> onDateChanged;

  const DateRangePicker({
    Key? key,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: firstDate,
              lastDate: lastDate,
            );
            onDateChanged(picked);
          },
          child: const Text('Chọn khoảng thời gian'),
        ),
      ],
    );
  }
}