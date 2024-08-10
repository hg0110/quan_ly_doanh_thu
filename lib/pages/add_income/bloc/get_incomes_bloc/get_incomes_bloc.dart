import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'get_incomes_event.dart';
part 'get_incomes_state.dart';

class GetIncomesBloc extends Bloc<GetIncomesEvent, GetIncomesState> {
  final TransactionRepository transactionRepository;

  GetIncomesBloc(this.transactionRepository) : super(GetIncomesInitial()) {
    on<GetIncomes>((event, emit) async {
      emit(GetIncomesLoading());
      try {
        List<Income> incomes = await transactionRepository.getIncomes();
        emit(GetIncomesSuccess(incomes));
      } catch (e) {
        emit(GetIncomesFailure());
      }
    });
  }
}
