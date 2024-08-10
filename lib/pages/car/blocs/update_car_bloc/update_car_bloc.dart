import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

part 'update_car_event.dart';
part 'update_car_state.dart';

class UpdateCarBloc extends Bloc<UpdateCarEvent, UpdateCarState> {
  final ShippingOrderRepository _carRepository;

  UpdateCarBloc(this._carRepository) : super(UpdateCarInitial()) {
    on<UpdateCarRequested>((event, emit) async {
      emit(UpdateCarLoading());
      try {
        final updatedCar = await _carRepository.updateCar(event.car);
        emit(UpdateCarSuccess());
      } catch (e) {
        emit(UpdateCarFailure());
      }
    });
  }
}
