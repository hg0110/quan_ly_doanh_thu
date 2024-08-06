part of 'create_driver_bloc.dart';

sealed class CreateDriverEvent extends Equatable {
  const CreateDriverEvent();

  @override
  List<Object> get props => [];
}

class CreateDriver extends CreateDriverEvent {
  final Driver driver;

  const CreateDriver(this.driver);

  @override
  List<Object> get props => [driver];
}