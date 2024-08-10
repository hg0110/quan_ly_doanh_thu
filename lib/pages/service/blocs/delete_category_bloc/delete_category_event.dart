part of 'delete_category_bloc.dart';

abstract class DeleteCategoryEvent {}

class DeleteCategory extends DeleteCategoryEvent {
  final String categoryId;

  DeleteCategory(this.categoryId);
}