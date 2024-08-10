import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'update_customer_event.dart';
part 'update_customer_state.dart';

class UpdateCustomerBloc
    extends Bloc<UpdateCustomerEvent, UpdateCustomerState> {
  final TransactionRepository _customerRepository;

  UpdateCustomerBloc(this._customerRepository)
      : super(UpdateCustomerInitial()) {
    on<UpdateCustomerRequested>((event, emit) async {
      emit(UpdateCustomerLoading());
      try {
        final updatedCustomer =
            await _customerRepository.updateCustomer(event.customer);
        emit(UpdateCustomerSuccess());
      } catch (e) {
        emit(UpdateCustomerFailure());
      }
    });
  }
}
