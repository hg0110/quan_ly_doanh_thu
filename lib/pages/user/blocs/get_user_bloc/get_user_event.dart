part of 'get_user_bloc.dart';

sealed class GetUserEvent extends Equatable {
  const GetUserEvent();

  @override
  List<Object> get props => [];
}

class GetUser extends GetUserEvent {}
class SearchUser extends GetUserEvent {
  final String email;
  const SearchUser(this.email);
}