
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shipping_order_repository/src/entities/shipping_order_entity.dart';

import '../shipping_order_repository.dart';

class FirebaseShippingOrderRepo implements ShippingOrderRepository {
	final shippingOrderCollection = FirebaseFirestore.instance.collection('shipping_orders');
	final carCollection = FirebaseFirestore.instance.collection('cars');


	@override
	Future<void> createCar(Car car) async {
		try {
			await carCollection
					.doc(car.carId)
					.set(car.toEntity().toDocument());
		} catch (e) {
			log(e.toString());
			rethrow;
		}
	}


	@override
	Future<void> updateCar(Car car) async {
		try {
			await carCollection
					.doc(car.carId)
					.update(car.toEntity().toDocument());
			return ;
		} catch (e) {
			log(e.toString());
			rethrow;
		}
	}

	@override
	Future<List<Car>> getCar() async {
		try {
			return await carCollection
					.get()
					.then((value) => value.docs.map((e) =>
					Car.fromEntity(CarEntity.fromDocument(e.data()))
			).toList());
		} catch (e) {
			log(e.toString());
			rethrow;
		}
	}
	@override
	Future<Car?> getCarByBKS(String BKS) async {
		try {
			final querySnapshot = await carCollection
					.where('BKS', isEqualTo: BKS)
					.get();if (querySnapshot.docs.isNotEmpty) {
				return Car.fromEntity(
						CarEntity.fromDocument(querySnapshot.docs.first.data()));
			} else {
				return null;
			}
		} catch (e) {
			// Handle potential errors (e.g., database connection errors)
			print('Error getting car by BKS: $e');
			return null;
		}
	}


	@override
	Future<Car?> deleteCar(String carId) async{
		try {
			final doc = await carCollection.doc(carId).get();
			if (doc.exists) {
				final car = Car.fromEntity(CarEntity.fromDocument(doc.data()!));
				await doc.reference.delete();
				return car;
			} else {
				return null;
			}
		} catch (e) {
			log(e.toString());
			return null;
		}
	}

	@override
	Future<void> createShippingOrder(ShippingOrder shippingOrder) async {
		try {
			await shippingOrderCollection
					.doc(shippingOrder.ShippingId)
					.set(shippingOrder.toEntity().toDocument());
		} catch (e) {
			log(e.toString());
			rethrow;
		}
	}

	@override
	Future<List<ShippingOrder>> getShippingOrder() async {
		try {
			return await shippingOrderCollection
					.get()
					.then((value) => value.docs.map((e) =>
					ShippingOrder.fromEntity(ShippingOrderEntity.fromDocument(e.data()))
			).toList());
		} catch (e) {
			log(e.toString());
			rethrow;
		}
	}

	@override
	Future<ShippingOrder?> getShippingOrderByName(String name) async {
		try {
			final querySnapshot = await shippingOrderCollection
					.where('name', isEqualTo: name)
					.get();if (querySnapshot.docs.isNotEmpty) {
				return ShippingOrder.fromEntity(
						ShippingOrderEntity.fromDocument(querySnapshot.docs.first.data()));
			} else {
				return null;
			}
		} catch (e) {
			// Handle potential errors (e.g., database connection errors)
			print('Error getting shippingOrder by name: $e');
			return null;
		}
	}

	Future<int> generateNextOrderId() async {
		// 1. Use a transaction to ensure atomicity
		return FirebaseFirestore.instance.runTransaction((transaction) async {
			// 2. Get the counter document
			final counterRef =
			FirebaseFirestore.instance.collection('counters').doc('shippingOrder');
			final counterDoc = await transaction.get(counterRef); // No await here

			// 3. Get the current ID
			int currentId = counterDoc.exists ? counterDoc ['value'] as int : 0;

			// 4. Increment the ID
			int nextId = currentId + 1;

			// 5. Update the counter document
			transaction.update(counterRef, {'value': nextId});

			// 6. Return the new ID
			return nextId;
		});
	}


}