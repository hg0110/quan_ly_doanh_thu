part of 'delete_shipping_order_bloc.dart';

abstract class DeleteShippingOrderState extends Equatable {
  const DeleteShippingOrderState();

  @override
  List<Object> get props => [];
}

final class DeleteShippingOrderInitial extends DeleteShippingOrderState {}

final class DeleteShippingOrderLoading extends DeleteShippingOrderState {}

final class DeleteShippingOrderSuccess extends DeleteShippingOrderState {}

final class DeleteShippingOrderFailure extends DeleteShippingOrderState {}