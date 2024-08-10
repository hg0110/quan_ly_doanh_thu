part of 'delete_category_bloc.dart';

abstract class DeleteCategoryState extends Equatable {
  const DeleteCategoryState();

  @override
  List<Object> get props => [];
}

final class DeleteCategoryInitial extends DeleteCategoryState {}

final class DeleteCategoryLoading extends DeleteCategoryState {}

final class DeleteCategorySuccess extends DeleteCategoryState {}

final class DeleteCategoryFailure extends DeleteCategoryState {}