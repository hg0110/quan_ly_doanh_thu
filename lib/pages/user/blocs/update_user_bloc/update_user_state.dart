part of 'update_user_bloc.dart';

abstract class UpdateUserState extends Equatable {
  const UpdateUserState();

  @override
  List<Object> get props => [];
}

class UpdateUserInitial extends UpdateUserState {}

class UpdateUserLoading extends UpdateUserState {}

class UpdateUserSuccess extends UpdateUserState {
  // final Driver driver;
  //
  // const UpdateDriverSuccess(this.driver);
  //
  // @override
  // List<Object> get props => [driver];
}

class UpdateUserFailure extends UpdateUserState {
  // final String error;
  //
  // const UpdateDriverFailure(this.error);
  //
  // @override
  // List<Object> get props => [error];
}
