part of 'delete_shipping_order_bloc.dart';

abstract class DeleteShippingOrderEvent {}

class DeleteShippingOrder extends DeleteShippingOrderEvent {
  final String ShippingId;

  DeleteShippingOrder(this.ShippingId);
}