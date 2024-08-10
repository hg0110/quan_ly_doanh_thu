part of 'delete_user_bloc.dart';

abstract class DeleteUserState extends Equatable {
  const DeleteUserState();

  @override
  List<Object> get props => [];
}

final class DeleteUserInitial extends DeleteUserState {}

final class DeleteUserLoading extends DeleteUserState {}

final class DeleteUserSuccess extends DeleteUserState {}

final class DeleteUserFailure extends DeleteUserState {}