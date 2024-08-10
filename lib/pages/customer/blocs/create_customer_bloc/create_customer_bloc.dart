import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'create_customer_event.dart';
part 'create_customer_state.dart';

class CreateCustomerBloc
    extends Bloc<CreateCustomerEvent, CreateCustomerState> {
  final TransactionRepository transactionRepository;

  CreateCustomerBloc(this.transactionRepository)
      : super(CreateCustomerInitial()) {
    on<CreateCustomer>((event, emit) async {
      emit(CreateCustomerLoading());
      try {
        await transactionRepository.createCustomer(event.customer);
        emit(CreateCustomerSuccess());
      } catch (e) {
        emit(CreateCustomerFailure());
      }
    });
  }
}
