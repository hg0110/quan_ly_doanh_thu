import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/src/entities/entities.dart';

import '../models/models.dart';

class TransactionEntity {
  String transactionId;
  ShippingOrder shippingOrder;
  Category category;
  Car car;
  DateTime date;
  int amount;
  String bills;
  final bool isRevenue;

  TransactionEntity({
    required this.transactionId,
    required this.shippingOrder,
    required this.category,
    required this.car,
    required this.date,
    required this.amount,
    required this.bills,
    required this.isRevenue,
  });

  Map<String, Object?> toDocument() {
    return {
      'transactionId': transactionId,
      'shippingOrder': shippingOrder.toEntity().toDocument(),
      'category': category.toEntity().toDocument(),
      'car': car.toEntity().toDocument(),
      'date': date,
      'amount': amount,
      'bills': bills,
      'isRevenue': true,
    };
  }

  static TransactionEntity fromDocument(Map<String, dynamic> doc) {
    return TransactionEntity(
      transactionId: doc['transactionId'],
      shippingOrder: ShippingOrder.fromEntity(ShippingOrderEntity.fromDocument(doc['shippingOrder'])),
      category:
          Category.fromEntity(CategoryEntity.fromDocument(doc['category'])),
      car:
          Car.fromEntity(CarEntity.fromDocument(doc['car'])),
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
      bills: doc['bills'],
      isRevenue: doc['isRevenue'],
    );
  }
}
