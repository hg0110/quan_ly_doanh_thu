part of 'delete_car_bloc.dart';

abstract class DeleteCarState extends Equatable {
  const DeleteCarState();

  @override
  List<Object> get props => [];
}

final class DeleteCarInitial extends DeleteCarState {}

final class DeleteCarLoading extends DeleteCarState {}

final class DeleteCarSuccess extends DeleteCarState {}

final class DeleteCarFailure extends DeleteCarState {}