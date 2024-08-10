import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryEntity {
  String categoryId;
  String name;
  String note;
  DateTime date;
  // String icon;
  // int color;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.note,
    required this.date,
    // required this.icon,
    // required this.color,
  });

  Map<String, Object?> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'note': note,
      'date': date,
      // 'icon': icon,
      // 'color': color,
    };
  }

  static CategoryEntity fromDocument(Map<String, dynamic> doc) {
    return CategoryEntity(
      categoryId: doc['categoryId'],
      name: doc['name'],
      note: doc['note'],
      date: (doc['date'] as Timestamp).toDate(),
      // icon: doc['icon'],
      // color: doc['color'],
    );
  }
}