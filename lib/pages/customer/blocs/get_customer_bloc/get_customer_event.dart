part of 'get_customer_bloc.dart';

sealed class GetCustomerEvent extends Equatable {
  const GetCustomerEvent();

  @override
  List<Object> get props => [];
}

class GetCustomer extends GetCustomerEvent {}