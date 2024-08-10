import '../entities/entities.dart';

class Category {
  String categoryId;
  String name;
  String note;
  DateTime date;
  // String icon;
  // int color;

  Category({
    required this.categoryId,
    required this.name,
    required this.note,
    required this.date,
    // required this.icon,
    // required this.color,
  });

  static final empty = Category(
    categoryId: '', 
    name: '',
    note: '',
    date: DateTime.now(),
      // icon: '',
      // color: 0
  );

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      note: note,
      date: date,
      // icon: icon,
      // color: color,
    );
  }

  static Category fromEntity(CategoryEntity entity) {
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      note: entity.note,
      date: entity.date,
      // icon: entity.icon,
      // color: entity.color,
    );
  }
}