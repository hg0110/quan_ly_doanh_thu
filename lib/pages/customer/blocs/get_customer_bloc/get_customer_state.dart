part of 'get_customer_bloc.dart';

sealed class GetCustomerState extends Equatable {
  const GetCustomerState();

  @override
  List<Object> get props => [];
}

final class GetCustomerInitial extends GetCustomerState {}

final class GetCustomerFailure extends GetCustomerState {}
final class GetCustomerLoading extends GetCustomerState {}
final class GetCustomerSuccess extends GetCustomerState {
  final List<Customer> customer;

  const GetCustomerSuccess(this.customer);

  @override
  List<Object> get props => [customer];
}
