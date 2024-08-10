part of 'get_Transaction_bloc.dart';

sealed class GetTransactionEvent extends Equatable {
  const GetTransactionEvent();

  @override
  List<Object> get props => [];
}

class GetTransaction extends GetTransactionEvent{}