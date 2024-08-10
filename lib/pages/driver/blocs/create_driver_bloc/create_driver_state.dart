part of 'create_driver_bloc.dart';

sealed class CreateDriverState extends Equatable {
  const CreateDriverState();

  @override
  List<Object> get props => [];
}

final class CreateDriverInitial extends CreateDriverState {}

final class CreateDriverFailure extends CreateDriverState {}
final class CreateDriverLoading extends CreateDriverState {}
final class CreateDriverSuccess extends CreateDriverState {}
