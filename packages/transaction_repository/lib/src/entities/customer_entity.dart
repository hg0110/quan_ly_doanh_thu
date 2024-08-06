import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerEntity {
   String customerId;
   String name;
   String address;
   String phone;
   String note;
   DateTime date;


  CustomerEntity({
    required this.customerId,
    required this.name,
    required this.address,
    required this.phone,
    required this.note,
    required this.date,
  });

  Map<String, Object?> toDocument() {
    return {
      'customerId': customerId,
      'name': name,
      'address': address,
      'phone': phone,
      'note': note,
      'date': date,
    };
  }

  static CustomerEntity fromDocument(Map<String, dynamic> doc) {
    return CustomerEntity(
      customerId: doc['customerId'],
      name: doc['name'],
      address: doc['address'],
      phone: doc['phone'],
      note: doc['note'],
      date: (doc['date'] as Timestamp).toDate(),
    );
  }

// @override
// List<Object?> get props => [customerId, name, address, phone];
}
