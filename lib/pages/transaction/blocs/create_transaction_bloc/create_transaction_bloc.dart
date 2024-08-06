import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/transaction.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'create_transaction_event.dart';
part 'create_transaction_state.dart';

class CreateTransactionBloc extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  TransactionRepository transactionRepository;

  CreateTransactionBloc(this.transactionRepository) : super(CreateTransactionInitial()) {
    on<CreateTransaction>((event, emit) async {
      emit(CreateTransactionLoading());
      try {
        await transactionRepository.createTransaction(event.transaction);
        emit(CreateTransactionSuccess());
      } catch (e) {
        emit(CreateTransactionFailure());
      }
    });
  }
}
