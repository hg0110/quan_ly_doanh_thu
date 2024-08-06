part of 'create_car_bloc.dart';

sealed class CreateCarEvent extends Equatable {
  const CreateCarEvent();

  @override
  List<Object> get props => [];
}

class CreateCar extends CreateCarEvent {
  final Car car;

  const CreateCar(this.car);

  @override
  List<Object> get props => [car];
}