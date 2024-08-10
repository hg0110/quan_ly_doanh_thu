import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_driver_event.dart';
part 'get_driver_state.dart';

class GetDriverBloc extends Bloc<GetDriverEvent, GetDriverState> {
  DriverRepository driverRepository;

  GetDriverBloc(this.driverRepository) : super(GetDriverInitial()) {
    on<GetDriver>((event, emit) async {
      emit(GetDriverLoading());
      try {
        List<Driver> driver = await driverRepository.getDriver();
        emit(GetDriverSuccess(driver));
      } catch (e) {
        emit(GetDriverFailure());
      }
    });
  }
}
