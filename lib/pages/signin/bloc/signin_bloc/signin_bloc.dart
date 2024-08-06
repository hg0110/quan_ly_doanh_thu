
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_doanh_thu/app.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {

  final _userRepository = userRepository;

  SignInBloc() :super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInProcess());
      try {
         await _userRepository.signIn(event.email, event.password);
        if (event.roles == 'admin') {
          emit(SignInSuccess(event.roles));
        } else {
          emit(const SignInFailure(message: 'Chỉ quản trị viên mới được phép đăng nhập.'));
        }
        // await _userRepository.signIn(event.email, event.password, event.roles);
        // emit(SignInSuccess(roles));
      } on FirebaseAuthException catch (e) {
        emit(SignInFailure(message: e.code));
      } catch (e) {
        emit(const SignInFailure());
      }
    });
    on<SignOutRequired>((event, emit) async {
      await _userRepository.logOut();
    });
  }
}
