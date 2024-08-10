import 'package:cloud_firestore/cloud_firestore.dart';

class DriverEntity {
   String driverId;
   String name;
   String address;
   String phone;
   String note;
   DateTime date;

  DriverEntity({
    required this.driverId,
    required this.name,
    required this.address,
    required this.phone,
    required this.note,
    required this.date,
  });

  Map<String, Object?> toDocument() {
    return {
      'driverId': driverId,
      'name': name,
      'address': address,
      'phone': phone,
      'note': note,
      'date': date,
    };
  }

  static DriverEntity fromDocument(Map<String, dynamic> doc) {
    return DriverEntity(
      driverId: doc['driverId'],
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
