part of 'signin_bloc.dart';

sealed class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

class SignInSuccess extends SignInState {
  // final String role;
  // const SignInSuccess(this.role);

  // @override
  // List<Object> get props => [role]; // Include role in the props list
}
class SignInFailure extends SignInState {
  final String? message;

  const SignInFailure({this.message});
}
class SignInProcess extends SignInState {}