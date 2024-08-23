import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/src/models/models.dart';
import 'package:transaction_repository/transaction_repository.dart';

class Transactions {
  String transactionId;
  ShippingOrder shippingOrder;
  Category category;
  Car car;
  DateTime date;
  int amount;
  String bills;
  // final bool isRevenue;

  Transactions({
    required this.transactionId,
    required this.shippingOrder,
    required this.category,
    required this.car,
    required this.date,
    required this.amount,
    required this.bills,
    // required this.isRevenue,
  });

  static final empty = Transactions(
    transactionId: '',
    shippingOrder: ShippingOrder.empty,
    category: Category.empty,
    car: Car.empty,
    date: DateTime.now(),
    amount: 0,
    bills: '',
    // isRevenue: true,
  );

  TransactionEntity toEntity() {
    return TransactionEntity(
      transactionId: transactionId,
      shippingOrder: shippingOrder,
      category: category,
      car: car,
      date: date,
      amount: amount,
      bills: bills,
      // isRevenue: isRevenue,
    );
  }

  static Transactions fromEntity(TransactionEntity entity) {
    return Transactions(
      transactionId: entity.transactionId,
      shippingOrder: entity.shippingOrder,
      category: entity.category,
      car: entity.car,
      date: entity.date,
      amount: entity.amount,
      bills: entity.bills,
      // isRevenue: entity.isRevenue,
    );
  }
}