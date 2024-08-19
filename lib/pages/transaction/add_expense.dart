import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/transaction/blocs/create_transaction_bloc/create_transaction_bloc.dart';
import 'package:shipping_order_repository/shipping_order_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

import '../car/blocs/get_car_bloc/get_car_bloc.dart';
import '../service//blocs/get_categories_bloc/get_categories_bloc.dart';
import '../service/category_creation.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryNoteController = TextEditingController();
  TextEditingController clientController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  Car? selectedCar;

  DateTime selectDate = DateTime.now();
  late Transactions transactions;
  bool isLoading = false;

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    transactions = Transactions.empty;
    transactions.transactionId = const Uuid().v1();
    selectedCar = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetCategoriesBloc>(
      create: (context) =>
          GetCategoriesBloc(FirebaseTransactionRepo())..add(GetCategories()),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return BlocBuilder<GetCarBloc, GetCarState>(
                  builder: (context1, state1) {
                    if (state1 is GetCarSuccess) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Thêm Phiếu Chi",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: TextFormField(
                                  controller: expenseController,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLength: 19,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon: const Icon(
                                      FontAwesomeIcons.dollarSign,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      // borderSide: BorderSide.none
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              TextFormField(
                                controller: categoryNameController,
                                textAlignVertical: TextAlignVertical.center,
                                readOnly: true,
                                onTap: () {},
                                decoration: InputDecoration(
                                  filled: true,
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        var newCategory =
                                            await getCategoryCreation(context);
                                        setState(() {
                                          state.categories
                                              .insert(0, newCategory);
                                        });
                                      },
                                      icon: const Icon(
                                        FontAwesomeIcons.plus,
                                        size: 16,
                                        color: Colors.grey,
                                      )),
                                  hintText: 'Dịch vụ',
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12)),
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                        itemCount: state.categories.length,
                                        itemBuilder: (context, int i) {
                                          return Card(
                                            child: ListTile(
                                              onTap: () {
                                                setState(() {
                                                  transactions.category =
                                                      state.categories[i];
                                                  categoryNameController.text =
                                                      transactions
                                                          .category.name;
                                                  categoryNoteController.text =
                                                      transactions
                                                          .category.note;
                                                });
                                              },
                                              title: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                          "Tên dịch vụ: "),
                                                      Text(state
                                                          .categories[i].name),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text("Ghi chú: "),
                                                      Text(state
                                                          .categories[i].note),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        })),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const SizedBox(height: 10),
                              DropdownButton<Car>(
                                hint: selectedCar == null
                                    ? const Text('Xe')
                                    : Text(
                                        selectedCar!.BKS,
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 13),
                                      ),
                                isExpanded: true,
                                iconSize: 40.0,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 16),
                                value: selectedCar,
                                items: state1.car.map((car) {
                                  return DropdownMenuItem<Car>(
                                    value: car,
                                    child: Text(car.BKS),
                                  );
                                }).toList(),
                                onChanged: (Car? newValue) {
                                  setState(() {
                                    selectedCar = newValue;
                                  });
                                },
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: dateController,
                                textAlignVertical: TextAlignVertical.center,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? newDate = await showDatePicker(
                                      context: context,
                                      initialDate: transactions.date,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)));

                                  if (newDate != null) {
                                    setState(() {
                                      dateController.text =
                                          DateFormat('dd/MM/yyyy')
                                              .format(newDate);
                                      selectDate = newDate;
                                      transactions.date = newDate;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(
                                    FontAwesomeIcons.clock,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  hintText: 'Date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none),
                                ),
                              ),
                              const SizedBox(
                                height: 32,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: kToolbarHeight,
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            transactions.amount = int.parse(
                                                expenseController.text);
                                            transactions.car =
                                                selectedCar ?? Car.empty;
                                            transactions.bills = 'chi';
                                            transactions.shippingOrder =
                                                ShippingOrder.empty;
                                          });

                                          context
                                              .read<CreateTransactionBloc>()
                                              .add(CreateTransaction(
                                                  transactions));
                                          setState(() {
                                            expenseController.clear();
                                            dateController.text =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(DateTime.now());
                                          });
                                          Navigator.pop(context, transactions);
                                          Navigator.of(context).pop();
                                        },
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12))),
                                        child: const Text(
                                          'Lưu',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.white),
                                        )),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
