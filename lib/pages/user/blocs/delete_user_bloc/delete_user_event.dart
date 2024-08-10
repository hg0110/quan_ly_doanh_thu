part of 'delete_user_bloc.dart';

abstract class DeleteUserEvent {}

class DeleteUser extends DeleteUserEvent {
  final String userId;

  DeleteUser(this.userId);
}