import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'delete_customer_event.dart';
part 'delete_customer_state.dart';

class DeleteCustomerBloc extends Bloc<DeleteCustomerEvent, DeleteCustomerState> {
  final TransactionRepository transactionRepository;

  DeleteCustomerBloc({required this.transactionRepository})
      : super(DeleteCustomerInitial()) {
    on<DeleteCustomer>((event, emit) async {
      emit(DeleteCustomerLoading());
      try {
        await transactionRepository.deleteCustomer(event.customerId);
        emit(DeleteCustomerSuccess());
      } catch (e) {
        emit(DeleteCustomerFailure());
      }
    });
  }
}
