import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'get_user_event.dart';

part 'get_user_state.dart';

class GetUserBloc extends Bloc<GetUserEvent, GetUserState> {
  UserRepository userRepository;

  GetUserBloc(this.userRepository) : super(GetUserInitial()) {
    on<GetUser>((event, emit) async {
      emit(GetUserLoading());
      try {
        List<MyUser> user = await userRepository.getUser();
        emit(GetUserSuccess(user));
      } catch (e) {
        emit(GetUserFailure());
      }
    });
  }
}
