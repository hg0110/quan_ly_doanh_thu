import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'update_user_event.dart';
part 'update_user_state.dart';

class UpdateUserBloc
    extends Bloc<UpdateUserEvent, UpdateUserState> {
  final UserRepository _userRepository;

  UpdateUserBloc(this._userRepository)
      : super(UpdateUserInitial()) {
    on<UpdateUserRequested>((event, emit) async {
      emit(UpdateUserLoading());
      try {
        final updatedUser =
            await _userRepository.updateUser(event.user);
        emit(UpdateUserSuccess());
      } catch (e) {
        emit(UpdateUserFailure());
      }
    });
  }
}
