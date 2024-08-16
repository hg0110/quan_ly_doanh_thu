import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transaction_repository/transaction_repository.dart';

class TransactionDetail extends StatefulWidget {
  final Transactions transaction;

  const TransactionDetail({super.key, required this.transaction});

  @override
  State<TransactionDetail> createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  Widget build(BuildContext context) {
    final transactions = widget.transaction.amount;
    final formatter = NumberFormat("#,##0");
    String formattedTotal = formatter.format(transactions);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi Tiết Giao Dịch',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  if (widget.transaction.bills == 'chi') ...[
                    const Text(
                      'PHIẾU CHI',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                  if (widget.transaction.bills == 'thu') ...[
                    const Text(
                      'PHIẾU THU',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
            if (widget.transaction.bills == 'chi') ...[
              const Text(
                'Thông tin Dịch vụ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('Tên dịch vụ: ${widget.transaction.category.name}'),
              Text('Ghi chú: ${widget.transaction.category.note}'),
              const Text(
                'Thông tin Xe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('Tên xe: ${widget.transaction.car.name}'),
              Text('Số hiệu: ${widget.transaction.car.BKS}'),
              Text('Ghi chú: ${widget.transaction.car.note}'),
            ],
            if (widget.transaction.bills == 'thu') ...[
              const Text(
                'Chi tiết Lệnh',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('Tên lệnh: ${widget.transaction.shippingOrder.name}'),
              const Text(
                'Thông tin Xe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('Tên xe: ${widget.transaction.shippingOrder.car.name}'),
              Text('Số hiệu: ${widget.transaction.shippingOrder.car.BKS}'),
              Text('Ghi chú: ${widget.transaction.shippingOrder.car.note}'),
              const Text(
                'Thông tin Lái Xe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                  'Tên lái xe: ${widget.transaction.shippingOrder.driver.name}'),
              Text(
                  'Địa chỉ: ${widget.transaction.shippingOrder.driver.address}'),
              Text(
                  'Số điện thoại: ${widget.transaction.shippingOrder.driver.phone}'),
              Text('Ghi chú: ${widget.transaction.shippingOrder.driver.note}'),
              // Text(transactions.shippingOrder.name),
              const Text(
                'Thông tin Khách Hàng',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                  'Tên khách hàng: ${widget.transaction.shippingOrder.customer.name}'),
              Text(
                  'Địa chỉ: ${widget.transaction.shippingOrder.customer.address}'),
              Text(
                  'Số điện thoại: ${widget.transaction.shippingOrder.customer.phone}'),
              Text(
                  'Ghi chú: ${widget.transaction.shippingOrder.customer.note}'),
            ],
            const SizedBox(height: 15),
            Text(
              'Ngày giao dịch: ${widget.transaction.date}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              'Số tiền: $formattedTotal',
              style: TextStyle(
                  fontSize: 20,
                  color: widget.transaction.bills == 'thu'
                      ? Colors.green
                      : Colors.red,
                  fontWeight: FontWeight.w400),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
