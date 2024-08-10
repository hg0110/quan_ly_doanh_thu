import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'delete_category_event.dart';
part 'delete_category_state.dart';

class DeleteCategoryBloc
    extends Bloc<DeleteCategoryEvent, DeleteCategoryState> {
  final TransactionRepository transactionRepository;

  DeleteCategoryBloc({required this.transactionRepository})
      : super(DeleteCategoryInitial()) {
    on<DeleteCategory>((event, emit) async {
      emit(DeleteCategoryLoading());
      try {
        await transactionRepository.deleteCategory(event.categoryId);
        emit(DeleteCategorySuccess());
      } catch (e) {
        emit(DeleteCategoryFailure());
      }
    });
  }
}
