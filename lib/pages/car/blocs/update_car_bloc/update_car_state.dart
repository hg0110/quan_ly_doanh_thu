part of 'update_car_bloc.dart';

abstract class UpdateCarState extends Equatable {
  const UpdateCarState();

  @override
  List<Object> get props => [];
}

class UpdateCarInitial extends UpdateCarState {}

class UpdateCarLoading extends UpdateCarState {}

class UpdateCarSuccess extends UpdateCarState {
  // final Driver driver;
  //
  // const UpdateDriverSuccess(this.driver);
  //
  // @override
  // List<Object> get props => [driver];
}

class UpdateCarFailure extends UpdateCarState {
  // final String error;
  //
  // const UpdateDriverFailure(this.error);
  //
  // @override
  // List<Object> get props => [error];
}