
import '../../transaction_repository.dart';

class Customer {
   String customerId;
   String name;
   String address;
   String phone;
   String note;
   DateTime date;

  Customer({
    required this.customerId,
    required this.name,
    required this.address,
    required this.phone,
    required this.note,
    required this.date,
  });

  static final empty = Customer(
    customerId: '',
    name: '',
    address: '',
    phone: '',
    note: '',
    date: DateTime.now(),
  );

  CustomerEntity toEntity() {
    return CustomerEntity(
      customerId: customerId,
      name: name,
      address: address,
      phone: phone,
      note: note,
      date: date,
    );
  }

  static Customer fromEntity(CustomerEntity entity) {
    return Customer(
      customerId: entity.customerId,
      name: entity.name,
      address: entity.address,
      phone: entity.phone,
      note: entity.note,
      date: entity.date,
    );
  }
}
