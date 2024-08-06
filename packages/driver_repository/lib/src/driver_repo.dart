import 'package:driver_repository/driver_repository.dart';

abstract class DriverRepository {

	Future<void> createDriver(Driver driver);

	Future<void> updateDriver(Driver driver);

	Future<List<Driver>> getDriver();

	Future<Driver?> getDriverByName(String name);

	Future<void> deleteDriver(String driverId);

}