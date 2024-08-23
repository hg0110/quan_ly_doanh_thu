// import 'package:transaction_repository/transaction_repository.dart';
//
// class Expense {
//   String expenseId;
//   Category category;
//   DateTime date;
//   int amount;
//   int totalExpenses;
//
//   Expense({
//     required this.expenseId,
//     required this.category,
//     required this.date,
//     required this.amount,
//     required this.totalExpenses,
//   });
//
//   static final empty = Expense(
//     expenseId: '',
//     category: Category.empty,
//     date: DateTime.now(),
//     amount: 0,
//     totalExpenses: 0,
//   );
//
//   ExpenseEntity toEntity() {
//     return ExpenseEntity(
//       expenseId: expenseId,
//       category: category,
//       date: date,
//       amount: amount,
//       totalExpenses: totalExpenses,
//     );
//   }
//
//   static Expense fromEntity(ExpenseEntity entity) {
//     return Expense(
//       expenseId: entity.expenseId,
//       category: entity.category,
//       date: entity.date,
//       amount: entity.amount,
//       totalExpenses: entity.totalExpenses,
//     );
//   }
// }