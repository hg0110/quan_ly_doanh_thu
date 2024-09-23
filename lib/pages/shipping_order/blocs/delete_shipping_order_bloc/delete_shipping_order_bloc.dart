import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';

part 'delete_shipping_order_event.dart';
part 'delete_shipping_order_state.dart';

class DeleteShippingOrderBloc
    extends Bloc<DeleteShippingOrderEvent, DeleteShippingOrderState> {
  final ShippingOrderRepository shippingOrderRepository;

  DeleteShippingOrderBloc({required this.shippingOrderRepository})
      : super(DeleteShippingOrderInitial()) {
    on<DeleteShippingOrder>((event, emit) async {
      emit(DeleteShippingOrderLoading());
      try {
        await shippingOrderRepository.deleteShippingOrder(event.ShippingId);
        emit(DeleteShippingOrderSuccess());
      } catch (e) {
        emit(DeleteShippingOrderFailure());
      }
    });
  }
}
