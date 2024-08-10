// part of 'expense_bloc.dart';
//
// enum ExpenseStatus { success, loading, failure }
//
// class ExpenseState extends Equatable {
//
// 	final ExpenseStatus status;
//   final Expense? expense;
//
//   const ExpenseState._({
//     this.status = ExpenseStatus.loading,
//     this.expense,
//   });
//
// 	const ExpenseState.loading() : this._();
//
// 	const ExpenseState.success(Expense expense) : this._(status: ExpenseStatus.success, expense: expense);
//
// 	const ExpenseState.failure() : this._(status: ExpenseStatus.failure);
//
// 	@override
//   List<Object?> get props => [status, expense];
// }