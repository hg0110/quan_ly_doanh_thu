import '../../driver_repository.dart';

class Driver {
  String driverId;
  String name;
  String address;
  String phone;
  String note;
  DateTime date;

  Driver({
    required this.driverId,
    required this.name,
    required this.address,
    required this.phone,
    required this.note,
    required this.date,
  });

  static final empty = Driver(
    driverId: '',
    name: '',
    address: '',
    phone: '',
    note: '',
    date: DateTime.now(),
  );

  DriverEntity toEntity() {
    return DriverEntity(
      driverId: driverId,
      name: name,
      address: address,
      phone: phone,
      note: note,
      date: date,
    );
  }

  static Driver fromEntity(DriverEntity entity) {
    return Driver(
      driverId: entity.driverId,
      name: entity.name,
      address: entity.address,
      phone: entity.phone,
      note: entity.note,
      date: entity.date,
    );
  }
}
