part of 'create_car_bloc.dart';

sealed class CreateCarState extends Equatable {
  const CreateCarState();

  @override
  List<Object> get props => [];
}

final class CreateCarInitial extends CreateCarState {}

final class CreateCarFailure extends CreateCarState {}
final class CreateCarLoading extends CreateCarState {}
final class CreateCarSuccess extends CreateCarState {}
