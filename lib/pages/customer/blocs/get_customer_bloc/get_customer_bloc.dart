import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'get_customer_event.dart';
part 'get_customer_state.dart';

class GetCustomerBloc extends Bloc<GetCustomerEvent, GetCustomerState> {
  TransactionRepository transactionRepository;

  GetCustomerBloc(this.transactionRepository) : super(GetCustomerInitial()) {
    on<GetCustomer>((event, emit) async {
      emit(GetCustomerLoading());
      try {
        List<Customer> customer = await transactionRepository.getCustomer();
        emit(GetCustomerSuccess(customer));
      } catch (e) {
        emit(GetCustomerFailure());
      }
    });
  }
}
