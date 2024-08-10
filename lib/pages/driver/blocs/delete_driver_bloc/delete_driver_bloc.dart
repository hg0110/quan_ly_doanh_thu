import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'delete_driver_event.dart';
part 'delete_driver_state.dart';

class DeleteDriverBloc extends Bloc<DeleteDriverEvent, DeleteDriverState> {
  final DriverRepository driverRepository;

  DeleteDriverBloc({required this.driverRepository}) : super(DeleteDriverInitial()) {
    on<DeleteDriver>((event, emit) async {
      emit(DeleteDriverLoading());
      try {
        await driverRepository.deleteDriver(event.driverId);
        emit(DeleteDriverSuccess());
      } catch (e) {
        emit(DeleteDriverFailure());
      }
    });
  }
}