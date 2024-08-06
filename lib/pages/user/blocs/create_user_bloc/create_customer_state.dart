part of 'create_customer_bloc.dart';

sealed class CreateCustomerState extends Equatable {
  const CreateCustomerState();

  @override
  List<Object> get props => [];
}

final class CreateCustomerInitial extends CreateCustomerState {}

final class CreateCustomerFailure extends CreateCustomerState {}
final class CreateCustomerLoading extends CreateCustomerState {}
final class CreateCustomerSuccess extends CreateCustomerState {}
