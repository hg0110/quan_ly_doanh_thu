import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_doanh_thu/pages/service/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/service/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:quan_ly_doanh_thu/pages/service/update_service.dart';
import 'package:transaction_repository/transaction_repository.dart';

import 'blocs/delete_category_bloc/delete_category_bloc.dart';
import 'category_creation.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  late Category category;
  bool isLoading = false;

  @override
  void initState() {
    category = Category.empty;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (context, state) {
              if (state is CreateCategorySuccess) {
                Navigator.pop(context, category);
                context.read<GetCategoriesBloc>().add(GetCategories());
              } else if (state is CreateCategoryLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is CreateCategoryFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không thể thêm dịch vụ')),
                );
                setState(() {
                  isLoading = false;
                });
              }
            },
          ),
          BlocListener<DeleteCategoryBloc, DeleteCategoryState>(
            listener: (context, state) {
              if (state is DeleteCategorySuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa dịch vụ thành công')),
                );
                context.read<GetCategoriesBloc>().add(GetCategories());
              } else if (state is DeleteCategoryFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Không xóa được dịch vụ')),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            title: const Text(
              "Dịch Vụ",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.80,
            width: MediaQuery.sizeOf(context).width,
            child: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
              builder: (context, state) {
                if (state is GetCategoriesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetCategoriesSuccess) {
                  state.categories
                      .sort((a, b) => b.date.compareTo(a.date));
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final Category category = state.categories[index];
                      return Dismissible(
                        key: Key(category.categoryId),
                        onDismissed: (direction) {
                          _showDeleteConfirmationDialog(context, category);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          surfaceTintColor: Colors.green,
                          shadowColor: Colors.green,
                          child: ListTile(
                            title: Row(
                              children: [
                                const Text("Tên Dịch Vụ: "),
                                Text(category.name),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text("Số hiệu: "),
                                    Text(category.note),
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     const Text("Ghi chú: "),
                                //     Text(category.date),
                                //   ],
                                // ),
                                Text(
                                  DateFormat('dd/MM/yy hh:mm')
                                      .format(category.date),
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:
                                      Theme.of(context).colorScheme.outline,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed:  ()async{
                                        await UpdateCategoryScreen(context, category);
                                        context.read<GetCategoriesBloc>().add(GetCategories());
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text("Error"),
                  );
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              // var newCategory =
              await getCategoryCreation(context);
              // setState(() {
              //   state.categories.insert(0, newCategory);
              // });
              // var newCar = await getAddCar(context);
              // if (newCar != null) {
              //   context.read<GetCarBloc>().add(GetCar());
              // }
            },
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext parentContext, Category category) async {
    return showDialog<void>(
      context: parentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có muốn xóa dịch vụ ${category.name}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Đồng ý'),
              onPressed: () {
                parentContext.read<DeleteCategoryBloc>().add(DeleteCategory(category.categoryId));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
