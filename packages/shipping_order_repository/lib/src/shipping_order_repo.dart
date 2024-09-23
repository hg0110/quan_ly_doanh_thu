import 'package:shipping_order_repository/shipping_order_repository.dart';

abstract class ShippingOrderRepository {

	Future<void> createCar(Car car);

	Future<void> updateCar(Car car);

	Future<List<Car>> getCar();

	Future<Car?> getCarByBKS(String BKS);

	Future<void> deleteCar(String carId);

	Future<void> createShippingOrder(ShippingOrder shippingOrder);

	Future<void> updateShippingOrder(ShippingOrder shippingOrder);

	Future<void> deleteShippingOrder(String ShippingId);

	Future<List<ShippingOrder>> getShippingOrder();

	Future<ShippingOrder?> getShippingOrderByName(String name);

	Future<int> generateNextOrderId();



}