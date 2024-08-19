import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transaction_repository/src/entities/category_entity.dart';
import 'package:transaction_repository/transaction_repository.dart';


class FirebaseTransactionRepo implements TransactionRepository {
  final transactionCollection =
      FirebaseFirestore.instance.collection('transactions');
  final categoryCollection =
      FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');
  final incomeCollection = FirebaseFirestore.instance.collection('incomes');
  final customerCollection = FirebaseFirestore.instance.collection('customers');



  Future<Map<int, List<Transactions>>> fetchTransactions(String period) async {
    // 1. Fetch all transactions from your data source
    final allTransactions = await getTransaction();

    // 2. Filter transactions based on the period
    switch (period) {
      case 'week':
        return {0: _getTransactionsByWeek(allTransactions)};
      case 'month':
        return getTransactionsByMonthOfYear(allTransactions);
      default:
        return {0: allTransactions};
    }
  }

  List<Transactions> _getTransactionsByWeek(List<Transactions> transactions) {
    final now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday -1));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));
    return transactions
        .where((t) => t.date.isAfter(startOfWeek) && t.date.isBefore(endOfWeek))
        .toList();
  }

  Map<int, List<Transactions>> getTransactionsByMonthOfYear(List<Transactions> transactions) {
    final now = DateTime.now();
    final currentYear = now.year;

    Map<int, List<Transactions>> transactionsByMonth = {};

    for (int month = 1; month <= 12; month++) {
      transactionsByMonth[month] = transactions
          .where((transaction) =>transaction.date.month == month && transaction.date.year == currentYear)
          .toList();
    }

    return transactionsByMonth;
  }

  List<Transactions> _getFutureTransactionsByYear(
      List<Transactions> transactions, DateTime now) {
    DateTime startOfYear = DateTime(now.year);
    DateTime endOfYear = DateTime(now.year + 1).subtract(const Duration(days: 1));
    return transactions
        .where((t) => t.date.isAfter(startOfYear) && t.date.isBefore(endOfYear))
        .toList();
  }


  @override
  Future<void> createTransaction(Transactions transaction) async {
    try {
      await transactionCollection
          .doc(transaction.transactionId)
          .set(transaction.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Transactions>> getTransaction() async {
    try {
      return await transactionCollection.get().then((value) => value.docs
          .map((e) => Transactions.fromEntity(TransactionEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(Category category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .update(category.toEntity().toDocument());
      return ;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      return await categoryCollection.get().then((value) => value.docs
          .map(
              (e) => Category.fromEntity(CategoryEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<Category?> getCategoryByName(String name) async {
    try {
      final querySnapshot = await categoryCollection
          .where('name', isEqualTo: name)
          .get();if (querySnapshot.docs.isNotEmpty) {
        return Category.fromEntity(
            CategoryEntity.fromDocument(querySnapshot.docs.first.data()));
      } else {
        return null;
      }
    } catch (e) {
      // Handle potential errors (e.g., database connection errors)
      print('Error getting Category by name: $e');
      return null;
    }
  }


  @override
  Future<Category?> deleteCategory(String categoryId) async{
    try {
      final doc = await categoryCollection.doc(categoryId).get();
      if (doc.exists) {
        final category = Category.fromEntity(CategoryEntity.fromDocument(doc.data()!));
        await doc.reference.delete();
        return category;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null; // Deletion failed
    }
  }

  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await expenseCollection.get().then((value) => value.docs
          .map((e) => Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> createIncome(Income income) async {
    try {
      await incomeCollection
          .doc(income.incomeId)
          .set(income.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Income>> getIncomes() async {
    try {
      return await incomeCollection.get().then((value) => value.docs
          .map((e) => Income.fromEntity(IncomeEntity.fromDocument(e.data())))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }




  @override
  Future<void> createCustomer(Customer customer) async {
    try {
      await customerCollection
          .doc(customer.customerId)
          .set(customer.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }


  @override
  Future<void> updateCustomer(Customer customer) async {
    try {
      await customerCollection
          .doc(customer.customerId)
          .update(customer.toEntity().toDocument());
      return ;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Customer>> getCustomer() async {
    try {
      return await customerCollection
          .get()
          .then((value) => value.docs.map((e) =>
          Customer.fromEntity(CustomerEntity.fromDocument(e.data()))
      ).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<Customer?> getCustomerByName(String name) async {
    try {
      final querySnapshot = await customerCollection
          .where('name', isEqualTo: name)
          .get();if (querySnapshot.docs.isNotEmpty) {
        return Customer.fromEntity(
            CustomerEntity.fromDocument(querySnapshot.docs.first.data()));
      } else {
        return null;
      }
    } catch (e) {
      // Handle potential errors (e.g., database connection errors)
      print('Error getting customer by name: $e');
      return null;
    }
  }


  @override
  Future<Customer?> deleteCustomer(String customerId) async{
    try {
      final doc = await customerCollection.doc(customerId).get();
      if (doc.exists) {
        final customer = Customer.fromEntity(CustomerEntity.fromDocument(doc.data()!));
        await doc.reference.delete();
        return customer;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      return null; // Deletion failed
    }
  }

}
