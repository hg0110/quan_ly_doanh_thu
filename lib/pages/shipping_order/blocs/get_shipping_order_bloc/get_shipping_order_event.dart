part of 'get_shipping_order_bloc.dart';

sealed class GetShippingOrderEvent extends Equatable {
  const GetShippingOrderEvent();

  @override
  List<Object> get props => [];
}

class GetShippingOrder extends GetShippingOrderEvent {}