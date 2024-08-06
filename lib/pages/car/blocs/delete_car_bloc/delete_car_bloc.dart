import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

part 'delete_car_event.dart';
part 'delete_car_state.dart';

class DeleteCarBloc extends Bloc<DeleteCarEvent, DeleteCarState> {
  final ShippingOrderRepository shippingOrderRepository;

  DeleteCarBloc({required this.shippingOrderRepository})
      : super(DeleteCarInitial()) {
    on<DeleteCar>((event, emit) async {
      emit(DeleteCarLoading());
      try {
        await shippingOrderRepository.deleteCar(event.carId);
        emit(DeleteCarSuccess());
      } catch (e) {
        emit(DeleteCarFailure());
      }
    });
  }
}

