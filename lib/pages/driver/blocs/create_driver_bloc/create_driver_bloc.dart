import 'package:bloc/bloc.dart';
import 'package:driver_repository/driver_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_driver_event.dart';
part 'create_driver_state.dart';

class CreateDriverBloc extends Bloc<CreateDriverEvent, CreateDriverState> {
  final DriverRepository driverRepository;

  CreateDriverBloc(this.driverRepository) : super(CreateDriverInitial()) {
    on<CreateDriver>((event, emit) async {
      emit(CreateDriverLoading());
      try {
        await driverRepository.createDriver(event.driver);
        emit(CreateDriverSuccess());
      } catch (e) {
        emit(CreateDriverFailure());
      }
    });
  }
}
