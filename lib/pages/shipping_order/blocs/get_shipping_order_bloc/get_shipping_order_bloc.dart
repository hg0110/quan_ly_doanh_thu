import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

part 'get_shipping_order_event.dart';
part 'get_shipping_order_state.dart';

class GetShippingOrderBloc
    extends Bloc<GetShippingOrderEvent, GetShippingOrderState> {
  ShippingOrderRepository shippingOrderRepository;

  GetShippingOrderBloc(this.shippingOrderRepository)
      : super(GetShippingOrderInitial()) {
    on<GetShippingOrder>((event, emit) async {
      emit(GetShippingOrderLoading());
      try {
        List<ShippingOrder> shippingOrder =
            await shippingOrderRepository.getShippingOrder();
        emit(GetShippingOrderSuccess(shippingOrder));
      } catch (e) {
        emit(GetShippingOrderFailure());
      }
    });
  }
}
