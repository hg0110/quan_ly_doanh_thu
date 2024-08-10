import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'delete_user_event.dart';
part 'delete_user_state.dart';

class DeleteUserBloc extends Bloc<DeleteUserEvent, DeleteUserState> {
  final UserRepository userRepository;

  DeleteUserBloc({required this.userRepository}) : super(DeleteUserInitial()) {
    on<DeleteUser>((event, emit) async {
      emit(DeleteUserLoading());
      try {
        await userRepository.deleteUser(event.userId);
        emit(DeleteUserSuccess());
      } catch (e) {
        emit(DeleteUserFailure());
      }
    });
  }
}
