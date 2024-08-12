import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../shipping_order_repository.dart';

class ShippingOrderEntity {
  String ShippingId;
  String name;
  String note;
  DateTime start_day;
  Car car;
  Driver driver;
  MyUser user;
  Customer customer;

  ShippingOrderEntity({
    required this.ShippingId,
    required this.name,
    required this.note,
    required this.start_day,
    required this.car,
    required this.driver,
    required this.user,
    required this.customer,
  });

  Map<String, Object?> toDocument() {
    return {
      'ShippingId': ShippingId,
      'name': name,
      'note': note,
      'start_day': start_day,
      'car': car.toEntity().toDocument(),
      'driver': driver.toEntity().toDocument(),
      'user': user.toEntity().toDocument(),
      'customer': customer.toEntity().toDocument(),
    };
  }

  static ShippingOrderEntity fromDocument(Map<String, dynamic> doc) {
    return ShippingOrderEntity(
      ShippingId: doc['ShippingId'],
      name: doc['name'],
      note: doc['note'],
      start_day: (doc['start_day'] as Timestamp).toDate(),
      car: Car.fromEntity(CarEntity.fromDocument(doc['car'])),
      driver: Driver.fromEntity(DriverEntity.fromDocument(doc['driver'])),
      user: MyUser.fromEntity(MyUserEntity.fromDocument(doc['user'])),
      customer: Customer.fromEntity(CustomerEntity.fromDocument(doc['customer'])),
    );
  }
}
