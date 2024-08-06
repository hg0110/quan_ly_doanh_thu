import 'package:bloc/bloc.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:equatable/equatable.dart';

part 'get_car_event.dart';
part 'get_car_state.dart';

class GetCarBloc extends Bloc<GetCarEvent, GetCarState> {
  ShippingOrderRepository carRepository;

  GetCarBloc(this.carRepository) : super(GetCarInitial()) {
    on<GetCar>((event, emit) async {
      emit(GetCarLoading());
      try {
        List<Car> car = await carRepository.getCar();
        emit(GetCarSuccess(car));
      } catch (e) {
        emit(GetCarFailure());
      }
    });
  }
}
