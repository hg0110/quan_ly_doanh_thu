part of 'update_service_bloc.dart';

abstract class UpdateCategoryEvent extends Equatable {
  const UpdateCategoryEvent();
  @override
  List<Object> get props => [];
}

class UpdateCategoryRequested extends UpdateCategoryEvent {
  final Category category;

  const UpdateCategoryRequested(this.category);

  @override
  List<Object> get props => [category];
}