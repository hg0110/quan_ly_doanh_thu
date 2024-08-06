part of 'delete_car_bloc.dart';

abstract class DeleteCarEvent {}

class DeleteCar extends DeleteCarEvent {
  final String carId;

  DeleteCar(this.carId);
}