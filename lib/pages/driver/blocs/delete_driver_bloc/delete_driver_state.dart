part of 'delete_driver_bloc.dart';

abstract class DeleteDriverState extends Equatable {
  const DeleteDriverState();

  @override
  List<Object> get props => [];
}

final class DeleteDriverInitial extends DeleteDriverState {}

final class DeleteDriverLoading extends DeleteDriverState {}

final class DeleteDriverSuccess extends DeleteDriverState {}

final class DeleteDriverFailure extends DeleteDriverState {}