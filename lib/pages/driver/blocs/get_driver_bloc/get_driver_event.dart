part of 'get_driver_bloc.dart';

sealed class GetDriverEvent extends Equatable {
  const GetDriverEvent();

  @override
  List<Object> get props => [];
}

class GetDriver extends GetDriverEvent {}