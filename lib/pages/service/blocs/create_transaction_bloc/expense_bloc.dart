// import 'dart:developer';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:expense_repository/transaction_repository.dart';
// import 'package:user_repository/driver_repository.dart';
//
// part 'expense_event.dart';
// part 'expense_state.dart';
//
// class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
// 	final ExpenseRepository _expenseRepository;
//
//   ExpenseBloc(FirebaseExpenseRepo firebaseExpenseRepo, {
// 		required ExpenseRepository expenseRepository
// 	}) : _expenseRepository = expenseRepository,
// 		super(const ExpenseState.loading()) {
//     on<GetExpense>((event, emit) async {
//       try {
// 				Expense expense = await _expenseRepository.getExpense(event.expenseId);
//         emit(ExpenseState.success(expense));
//       } catch (e) {
// 			log(e.toString());
// 			emit(const ExpenseState.failure());
//       }
//     });
//   }
// }
