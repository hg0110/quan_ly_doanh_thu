import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/transaction.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'create_expense_event.dart';
part 'create_expense_state.dart';

class CreateExpenseBloc extends Bloc<CreateExpenseEvent, CreateExpenseState> {
  TransactionRepository transactionRepository;

  CreateExpenseBloc(this.transactionRepository) : super(CreateExpenseInitial()) {
    on<CreateExpense>((event, emit) async {
      emit(CreateExpenseLoading());
      try {
        await transactionRepository.createExpense(event.expense);
        emit(CreateExpenseSuccess());
      } catch (e) {
        emit(CreateExpenseFailure());
      }
    });
  }
}
