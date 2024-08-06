part of 'delete_customer_bloc.dart';

abstract class DeleteCustomerEvent {}

class DeleteCustomer extends DeleteCustomerEvent {
  final String customerId;

  DeleteCustomer(this.customerId);
}