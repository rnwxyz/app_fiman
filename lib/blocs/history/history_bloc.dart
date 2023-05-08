import 'package:bloc/bloc.dart';

import '../../models/transaction_model.dart';
import '../../repositories/database/transcation_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    final TransactionRepository transactionRepository = TransactionRepository();
    on<HistoryFetchEvent>(
      (event, emit) async {
        try {
          emit(HistoryLoading());
          final List<TransactionModel> transactionModels =
              await transactionRepository.getTransactions();
          emit(HistorySuccess(transactionModels));
        } catch (e) {
          emit(HistoryError(e.toString()));
        }
      },
    );
  }
}
