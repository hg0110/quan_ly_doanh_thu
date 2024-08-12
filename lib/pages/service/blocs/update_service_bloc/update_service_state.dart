part of 'update_service_bloc.dart';

abstract class UpdateCategoryState extends Equatable {
  const UpdateCategoryState();

  @override
  List<Object> get props => [];
}

class UpdateCategoryInitial extends UpdateCategoryState {}

class UpdateCategoryLoading extends UpdateCategoryState {}

class UpdateCategorySuccess extends UpdateCategoryState {
  // final Driver driver;
  //
  // const UpdateDriverSuccess(this.driver);
  //
  // @override
  // List<Object> get props => [driver];
}

class UpdateCategoryFailure extends UpdateCategoryState {
  // final String error;
  //
  // const UpdateDriverFailure(this.error);
  //
  // @override
  // List<Object> get props => [error];
}