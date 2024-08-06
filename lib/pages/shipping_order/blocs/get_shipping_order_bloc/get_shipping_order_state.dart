part of 'get_shipping_order_bloc.dart';

sealed class GetShippingOrderState extends Equatable {
  const GetShippingOrderState();

  @override
  List<Object> get props => [];
}

final class GetShippingOrderInitial extends GetShippingOrderState {}

final class GetShippingOrderFailure extends GetShippingOrderState {}
final class GetShippingOrderLoading extends GetShippingOrderState {}
final class GetShippingOrderSuccess extends GetShippingOrderState {
  final List<ShippingOrder> shippingOrder;

  const GetShippingOrderSuccess(this.shippingOrder);

  @override
  List<Object> get props => [shippingOrder];
}
