part of 'update_customer_bloc.dart';

abstract class UpdateCustomerEvent extends Equatable {
  const UpdateCustomerEvent();

  @override
  List<Object> get props => [];
}

class UpdateCustomerRequested extends UpdateCustomerEvent {
  final Customer customer;

  const UpdateCustomerRequested(this.customer);

  @override
  List<Object> get props => [customer];
}
