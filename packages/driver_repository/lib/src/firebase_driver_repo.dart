import 'dart:developer';

import 'package:driver_repository/driver_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDriverRepo implements DriverRepository {
  final driverCollection = FirebaseFirestore.instance.collection('drivers');

  @override
  Future<void> createDriver(Driver driver) async {
    try {
      await driverCollection
          .doc(driver.driverId)
          .set(driver.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateDriver(Driver driver) async {
    try {
      await driverCollection
          .doc(driver.driverId)
          .update(driver.toEntity().toDocument());
      return ;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Driver>> getDriver() async {
    try {
      return await driverCollection.get().then((value) => value.docs
          .map((e) => Driver.fromEntity(DriverEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Driver?> getDriverByName(String name) async {
    try {
      final querySnapshot = await driverCollection
          .where('name', isEqualTo: name)
          .get();if (querySnapshot.docs.isNotEmpty) {
        return Driver.fromEntity(
            DriverEntity.fromDocument(querySnapshot.docs.first.data()));
      } else {
        return null;
      }
    } catch (e) {
      // Handle potential errors (e.g., database connection errors)
      print('Error getting driver by name: $e');
      return null;
    }
  }

  @override
  Future<Driver?> deleteDriver(String driverId) async{
    try {
      final doc = await driverCollection.doc(driverId).get();
      if (doc.exists) {
        final driver = Driver.fromEntity(DriverEntity.fromDocument(doc.data()!));
        await doc.reference.delete();
        return driver;
      } else {
        return null; // Driver not found
      }
    } catch (e) {
      log(e.toString());
      return null; // Deletion failed
    }
  }

}
