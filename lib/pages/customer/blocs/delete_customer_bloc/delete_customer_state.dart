part of 'delete_customer_bloc.dart';

abstract class DeleteCustomerState extends Equatable {
  const DeleteCustomerState();

  @override
  List<Object> get props => [];
}

final class DeleteCustomerInitial extends DeleteCustomerState {}

final class DeleteCustomerLoading extends DeleteCustomerState {}

final class DeleteCustomerSuccess extends DeleteCustomerState {}

final class DeleteCustomerFailure extends DeleteCustomerState {}