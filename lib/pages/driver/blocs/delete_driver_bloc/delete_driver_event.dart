part of 'delete_driver_bloc.dart';

abstract class DeleteDriverEvent {}

class DeleteDriver extends DeleteDriverEvent {
  final String driverId;

  DeleteDriver(this.driverId);
}