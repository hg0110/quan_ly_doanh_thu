part of 'signin_bloc.dart';


sealed class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}


class SignInRequired extends SignInEvent{
  final String email;
  final String password;
  final String roles;

  const SignInRequired(this.email, this.password, this.roles);

  @override
  List<Object> get props => [email, password, roles];
}

class SignOutRequired extends SignInEvent{

  const SignOutRequired();
}
