part of 'history_bloc.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistorySuccess extends HistoryState {
  final List<TransactionModel> transactionModels;

  HistorySuccess(this.transactionModels);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
