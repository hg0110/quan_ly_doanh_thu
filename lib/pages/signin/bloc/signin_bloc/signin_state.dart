part of 'signin_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

class SignInSuccess extends SignInState {
  final String roles;
  const SignInSuccess(this.roles);

  @override
  List<Object> get props => [roles]; // Include role in the props list
}
class SignInFailure extends SignInState {
  final String? message;

  const SignInFailure({this.message});
}
class SignInProcess extends SignInState {}