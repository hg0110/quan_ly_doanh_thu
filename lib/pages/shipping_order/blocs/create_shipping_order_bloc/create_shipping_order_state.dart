part of 'create_shipping_order_bloc.dart';

sealed class CreateShippingOrderState extends Equatable {
  const CreateShippingOrderState();

  @override
  List<Object> get props => [];
}

final class CreateShippingOrderInitial extends CreateShippingOrderState {}

final class CreateShippingOrderFailure extends CreateShippingOrderState {}
final class CreateShippingOrderLoading extends CreateShippingOrderState {}
final class CreateShippingOrderSuccess extends CreateShippingOrderState {}
