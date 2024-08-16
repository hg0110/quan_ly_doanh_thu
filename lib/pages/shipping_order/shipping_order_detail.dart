import 'package:flutter/material.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

class ShippingOrderDetail extends StatefulWidget {
  final ShippingOrder shippingOrder;

  const ShippingOrderDetail({super.key, required this.shippingOrder});

  @override
  State<ShippingOrderDetail> createState() => _ShippingOrderDetailState();
}

class _ShippingOrderDetailState extends State<ShippingOrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi Tiết Lệnh Vận Chuyển',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tên lệnh: ${widget.shippingOrder.name}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Thông tin Khách Hàng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Tên khách hàng: ${widget.shippingOrder.customer.name}'),
            Text('Địa chỉ: ${widget.shippingOrder.customer.address}'),
            Text('Số điện thoại: ${widget.shippingOrder.customer.phone}'),
            Text('Ghi chú: ${widget.shippingOrder.customer.note}'),
            const Text(
              'Thông tin Lái Xe',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Tên lái xe: ${widget.shippingOrder.driver.name}'),
            Text('Địa chỉ: ${widget.shippingOrder.driver.address}'),
            Text('Số điện thoại: ${widget.shippingOrder.driver.phone}'),
            Text('Ghi chú: ${widget.shippingOrder.driver.note}'),
            const Text(
              'Thông tin Xe',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Tên xe: ${widget.shippingOrder.car.name}'),
            Text('Số hiệu: ${widget.shippingOrder.car.BKS}'),
            Text('Ghi chú: ${widget.shippingOrder.car.note}'),
            SizedBox(
              height: 16,
            ),
            Text('Ghi Chú: ${widget.shippingOrder.note}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('Ngày bắt đầu: ${widget.shippingOrder.start_day}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('Ngày hoàn thành: ${widget.shippingOrder.end_day}',
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('Trạng thái: ${widget.shippingOrder.status}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: widget.shippingOrder.status == 'đang hoạt động'
                      ? Colors.green
                      : Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}
