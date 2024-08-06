part of 'get_driver_bloc.dart';

sealed class GetDriverState extends Equatable {
  const GetDriverState();

  @override
  List<Object> get props => [];
}

final class GetDriverInitial extends GetDriverState {}

final class GetDriverFailure extends GetDriverState {}
final class GetDriverLoading extends GetDriverState {}
final class GetDriverSuccess extends GetDriverState {
  final List<Driver> driver;

  const GetDriverSuccess(this.driver);

  @override
  List<Object> get props => [driver];
}
