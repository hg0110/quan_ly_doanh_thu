import 'package:transaction_repository/transaction_repository.dart';

abstract class TransactionRepository {

  Future<void> createTransaction(Transactions transaction);

  Future<List<Transactions>> getTransaction();

  Future<void> createCategory(Category category);

  Future<List<Category>> getCategory();

	Future<Category?> getCategoryByName(String name);

	Future<void> updateCategory(Category category);

  Future<void> deleteCategory(String categoryId);

  // Future<void> createExpense(Expense expense);
  //
  // Future<List<Expense>> getExpenses();
  //
  // Future<void> createIncome(Income income);
  //
  // Future<List<Income>> getIncomes();

	Future<void> createCustomer(Customer customer);

	Future<void> updateCustomer(Customer customer);

	Future<List<Customer>> getCustomer();

	Future<Customer?> getCustomerByName(String name);

  Future<void> deleteCustomer(String customerId);

}