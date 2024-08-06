import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

part 'create_shipping_order_event.dart';
part 'create_shipping_order_state.dart';

class CreateShippingOrderBloc
    extends Bloc<CreateShippingOrderEvent, CreateShippingOrderState> {
  final ShippingOrderRepository shippingOrderRepository;

  CreateShippingOrderBloc(this.shippingOrderRepository)
      : super(CreateShippingOrderInitial()) {
    on<CreateShippingOrder>((event, emit) async {
      emit(CreateShippingOrderLoading());
      try {
        await shippingOrderRepository.createShippingOrder(event.shippingOrder);
        emit(CreateShippingOrderSuccess());
      } catch (e) {
        emit(CreateShippingOrderFailure());
      }
    });
  }
}
