// import 'package:transaction_repository/src/models/customer.dart';
// import 'package:transaction_repository/transaction_repository.dart';
//
// import '../entities/income_entity.dart';
//
// class Income {
//   String incomeId;
//   Customer customer;
//   DateTime date;
//   int amount;
//   int totalIncomes;
//
//   Income({
//     required this.incomeId,
//     required this.customer,
//     required this.date,
//     required this.amount,
//     required this.totalIncomes,
//   });
//
//   static final empty = Income(
//     incomeId: '',
//     customer: Customer.empty,
//     date: DateTime.now(),
//     amount: 0,
//     totalIncomes: 0,
//   );
//
//   IncomeEntity toEntity() {
//     return IncomeEntity(
//       incomeId: incomeId,
//       customer: customer,
//       date: date,
//       amount: amount,
//       totalIncomes: totalIncomes,
//     );
//   }
//
//   static Income fromEntity(IncomeEntity entity) {
//     return Income(
//       incomeId: entity.incomeId,
//       customer: entity.customer,
//       date: entity.date,
//       amount: entity.amount,
//       totalIncomes: entity.totalIncomes,
//     );
//   }
// }