import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

import 'blocs/create_category_bloc/create_category_bloc.dart';

Future getCategoryCreation(BuildContext context) {

  return showDialog(
      context: context,
      builder: (ctx) {
        TextEditingController categoryNameController = TextEditingController();
        TextEditingController categoryNoteController = TextEditingController();
        bool isLoading = false;
        Category category = Category.empty;

        return BlocProvider.value(
          value: context.read<CreateCategoryBloc>(),
          child: StatefulBuilder(
            builder: (ctx, setState) {
              return BlocListener<CreateCategoryBloc, CreateCategoryState>(
                listener: (context, state) {
                  if (state is CreateCategorySuccess) {
                    Navigator.pop(ctx, category);
                  } else if (state is CreateCategoryLoading) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                },
                child: ListView(
                  children: [
                    AlertDialog(
                      title: const Text('Thêm dịch vụ'),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: categoryNameController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Tên Dịch Vụ',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: categoryNoteController,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Ghi chú',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: kToolbarHeight,
                              child: isLoading == true
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        // Create Category Object and POP
                                        setState(() {
                                          category.categoryId =
                                              const Uuid().v1();
                                          category.name =
                                              categoryNameController.text;
                                          category.note =
                                              categoryNoteController.text;
                                          // category.icon = iconSelected;
                                          // category.color = categoryColor.value;
                                        });

                                        context
                                            .read<CreateCategoryBloc>()
                                            .add(CreateCategory(category));
                                      },
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12))),
                                      child: const Text(
                                        'Lưu',
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.white),
                                      )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      });
}
