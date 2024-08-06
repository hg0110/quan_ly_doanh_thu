part of 'create_shipping_order_bloc.dart';

sealed class CreateShippingOrderEvent extends Equatable {
  const CreateShippingOrderEvent();

  @override
  List<Object> get props => [];
}

class CreateShippingOrder extends CreateShippingOrderEvent {
  final ShippingOrder shippingOrder;


  const CreateShippingOrder(this.shippingOrder);

  @override
  List<Object> get props => [shippingOrder];
}