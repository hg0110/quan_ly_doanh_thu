import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transaction_repository/src/models/customer.dart';

import '../../transaction_repository.dart';

class IncomeEntity {
  String incomeId;
  Customer customer;
  DateTime date;
  int amount;
  int totalIncomes;

  IncomeEntity({
    required this.incomeId,
    required this.customer,
    required this.date,
    required this.amount,
    required this.totalIncomes,
  });

  Map<String, Object?> toDocument() {
    return {
      'incomeId': incomeId,
      'customer': customer.toEntity().toDocument(),
      'date': date,
      'amount': amount,
      'totalIncomes': totalIncomes,
    };
  }

  static IncomeEntity fromDocument(Map<String, dynamic> doc) {
    return IncomeEntity(
      incomeId: doc['incomeId'],
      customer:
      Customer.fromEntity(CustomerEntity.fromDocument(doc['customer'])),
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
      totalIncomes: doc['totalIncomes'],
    );
  }
}