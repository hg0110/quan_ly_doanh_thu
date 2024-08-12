import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'update_service_event.dart';
part 'update_service_state.dart';

class UpdateCategoryBloc extends Bloc<UpdateCategoryEvent, UpdateCategoryState> {
  final TransactionRepository _transactionRepository;

  UpdateCategoryBloc(this._transactionRepository) : super(UpdateCategoryInitial()) {
    on<UpdateCategoryRequested>((event, emit) async {
      emit(UpdateCategoryLoading());
      try {
        final updatedCar = await _transactionRepository.updateCategory(event.category);
        emit(UpdateCategorySuccess());
      } catch (e) {
        emit(UpdateCategoryFailure());
      }
    });
  }
}
