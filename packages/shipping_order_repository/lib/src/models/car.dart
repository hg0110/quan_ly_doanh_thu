import '../../shipping_order_repository.dart';

class Car {
  String carId;
  String name;
  String BKS;
  String note;
  String status;
  DateTime date;

  Car({
    required this.carId,
    required this.name,
    required this.BKS,
    required this.note,
    required this.status,
    required this.date,
  });

  static final empty = Car(
    carId: '',
    name: '',
    BKS: '',
    note: '',
    status: '',
    date: DateTime.now(),
  );

  CarEntity toEntity() {
    return CarEntity(
      carId: carId,
      name: name,
      BKS: BKS,
      note: note,
      status: status,
      date: date,
    );
  }

  static Car fromEntity(CarEntity entity) {
    return Car(
      carId: entity.carId,
      name: entity.name,
      BKS: entity.BKS,
      note: entity.note,
      status: entity.status,
      date: entity.date,
    );
  }
}
