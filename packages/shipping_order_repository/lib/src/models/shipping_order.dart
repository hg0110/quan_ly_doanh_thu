import 'package:driver_repository/driver_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../shipping_order_repository.dart';
import '../entities/shipping_order_entity.dart';

class ShippingOrder {
  String ShippingId;
  String name;
  String note;
  DateTime start_day;
  Car car;
  Driver driver;
  MyUser user;
  Customer customer;

  ShippingOrder({
    required this.ShippingId,
    required this.name,
    required this.note,
    required this.start_day,
    required this.car,
    required this.driver,
    required this.user,
    required this.customer,
  });

  static final empty = ShippingOrder(
    ShippingId: '',
    name: '',
    note: '',
    start_day: DateTime.now(),
    car: Car.empty,
    driver: Driver.empty,
    user: MyUser.empty,
    customer: Customer.empty,
  );

  ShippingOrderEntity toEntity() {
    return ShippingOrderEntity(
      ShippingId: ShippingId,
      name: name,
      note: note,
      start_day: start_day,
      car: car,
      driver: driver,
      user: user,
      customer: customer,
    );
  }

  static ShippingOrder fromEntity(ShippingOrderEntity entity) {
    return ShippingOrder(
      ShippingId: entity.ShippingId,
      name: entity.name,
      note: entity.note,
      start_day: entity.start_day,
      car: entity.car,
      driver: entity.driver,
      user: entity.user,
      customer: entity.customer,
    );
  }
}
