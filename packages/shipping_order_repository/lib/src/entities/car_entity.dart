import 'package:cloud_firestore/cloud_firestore.dart';

class CarEntity {
   String carId;
   String name;
   String BKS;
   String note;
   DateTime  date;

  CarEntity({
    required this.carId,
    required this.name,
    required this.BKS,
    required this.note,
    required this.date,
  });

  Map<String, Object?> toDocument() {
    return {
      'carId': carId,
      'name': name,
      'BKS': BKS,
      'note': note,
      'date': date,
    };
  }

  static CarEntity fromDocument(Map<String, dynamic> doc) {
    return CarEntity(
      carId: doc['carId'],
      name: doc['name'],
      BKS: doc['BKS'],
      note: doc['note'],
      date: (doc['date'] as Timestamp).toDate(),
    );
  }

// @override
// List<Object?> get props => [customerId, name, address, phone];
}
