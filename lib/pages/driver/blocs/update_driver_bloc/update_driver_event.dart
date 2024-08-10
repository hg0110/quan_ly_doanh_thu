part of 'update_driver_bloc.dart';

abstract class UpdateDriverEvent extends Equatable {
  const UpdateDriverEvent();
  @override
  List<Object> get props => [];
}

class UpdateDriverRequested extends UpdateDriverEvent {
  final Driver driver;

  const UpdateDriverRequested(this.driver);

  @override
  List<Object> get props => [driver];
}