import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'update_driver_event.dart';
part 'update_driver_state.dart';

class UpdateDriverBloc extends Bloc<UpdateDriverEvent, UpdateDriverState> {
  final DriverRepository _driverRepository;

  UpdateDriverBloc(this._driverRepository) : super(UpdateDriverInitial()) {
    on<UpdateDriverRequested>((event, emit) async {
      emit(UpdateDriverLoading());
      try{
        final updatedDriver = await _driverRepository.updateDriver(event.driver);
        emit(UpdateDriverSuccess());
      } catch (e) {
        emit(UpdateDriverFailure());
      }
    });
  }
}