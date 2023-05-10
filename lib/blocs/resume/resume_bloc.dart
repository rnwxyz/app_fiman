import 'package:app_fiman/models/resume_model.dart';
import 'package:app_fiman/repositories/database/transcation_repository.dart';
import 'package:bloc/bloc.dart';

part 'resume_event.dart';
part 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  ResumeBloc() : super(ResumeInitial()) {
    final TransactionRepository transactionRepository = TransactionRepository();

    on<ResumeFetch>((event, emit) async {
      try {
        emit(ResumeLoading());
        final transactionSum = await transactionRepository.getTransactionSum();
        final resumeMonth =
            await transactionRepository.getTransactionResumeThisMonth();
        emit(ResumeLoaded(transactionSum, resumeMonth));
      } catch (e) {
        emit(ResumeError(e.toString()));
      }
    });
  }
}
