part of 'update_driver_bloc.dart';

abstract class UpdateDriverState extends Equatable {
  const UpdateDriverState();

  @override
  List<Object> get props => [];
}

class UpdateDriverInitial extends UpdateDriverState {}

class UpdateDriverLoading extends UpdateDriverState {}

class UpdateDriverSuccess extends UpdateDriverState {
  // final Driver driver;
  //
  // const UpdateDriverSuccess(this.driver);
  //
  // @override
  // List<Object> get props => [driver];
}

class UpdateDriverFailure extends UpdateDriverState {
  // final String error;
  //
  // const UpdateDriverFailure(this.error);
  //
  // @override
  // List<Object> get props => [error];
}