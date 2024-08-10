part of 'update_user_bloc.dart';

abstract class UpdateUserEvent extends Equatable {
  const UpdateUserEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserRequested extends UpdateUserEvent {
  final MyUser user;

  const UpdateUserRequested(this.user);

  @override
  List<Object> get props => [user];
}
