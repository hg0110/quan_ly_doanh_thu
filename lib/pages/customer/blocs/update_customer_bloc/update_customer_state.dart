part of 'update_customer_bloc.dart';

abstract class UpdateCustomerState extends Equatable {
  const UpdateCustomerState();

  @override
  List<Object> get props => [];
}

class UpdateCustomerInitial extends UpdateCustomerState {}

class UpdateCustomerLoading extends UpdateCustomerState {}

class UpdateCustomerSuccess extends UpdateCustomerState {
  // final Driver driver;
  //
  // const UpdateDriverSuccess(this.driver);
  //
  // @override
  // List<Object> get props => [driver];
}

class UpdateCustomerFailure extends UpdateCustomerState {
  // final String error;
  //
  // const UpdateDriverFailure(this.error);
  //
  // @override
  // List<Object> get props => [error];
}
