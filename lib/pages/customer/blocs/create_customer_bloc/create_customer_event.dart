part of 'create_customer_bloc.dart';

sealed class CreateCustomerEvent extends Equatable {
  const CreateCustomerEvent();

  @override
  List<Object> get props => [];
}

class CreateCustomer extends CreateCustomerEvent {
  final Customer customer;

  const CreateCustomer(this.customer);

  @override
  List<Object> get props => [customer];
}