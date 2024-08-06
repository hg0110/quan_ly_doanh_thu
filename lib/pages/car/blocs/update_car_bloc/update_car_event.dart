part of 'update_car_bloc.dart';

abstract class UpdateCarEvent extends Equatable {
  const UpdateCarEvent();
  @override
  List<Object> get props => [];
}

class UpdateCarRequested extends UpdateCarEvent {
  final Car car;

  const UpdateCarRequested(this.car);

  @override
  List<Object> get props => [car];
}