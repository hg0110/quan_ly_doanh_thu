import 'package:bloc/bloc.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:equatable/equatable.dart';

part 'create_car_event.dart';
part 'create_car_state.dart';

class CreateCarBloc extends Bloc<CreateCarEvent, CreateCarState> {
  final ShippingOrderRepository carRepository;

  CreateCarBloc(this.carRepository) : super(CreateCarInitial()) {
    on<CreateCar>((event, emit) async {
      emit(CreateCarLoading());
      try {
        await carRepository.createCar(event.car);
        emit(CreateCarSuccess());
      } catch (e) {
        emit(CreateCarFailure());
      }
    });
  }
}
