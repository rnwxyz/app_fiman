import 'package:bloc/bloc.dart';

import '../../models/transaction_model.dart';
import '../../repositories/database/transcation_repository.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    int offset = -1;
    List<TransactionModel> transactionData = [];
    final TransactionRepository transactionRepository = TransactionRepository();
    on<HistoryFetchEvent>(
      (event, emit) async {
        try {
          emit(HistoryLoading());
          if (event.loadMore) {
            offset++;
          } else {
            offset = 0;
            transactionData = [];
          }

          final List<TransactionModel> transactionModels =
              await transactionRepository.getTransactions(offset, event.search,
                  event.sort ?? '', event.categoryId ?? 0);
          transactionData.addAll(transactionModels);
          emit(HistorySuccess(transactionData));
        } catch (e) {
          emit(HistoryError(e.toString()));
        }
      },
    );
    on<HistoryDeleteEvent>(
      (event, emit) async {
        try {
          emit(HistoryLoading());
          await transactionRepository.deleteTransaction(event.id);
          transactionData.removeWhere((element) => element.id == event.id);
          emit(HistorySuccess(transactionData));
        } catch (e) {
          emit(HistoryError(e.toString()));
        }
      },
    );
  }
}
