import 'package:bloc/bloc.dart';

part 'history_filter_event.dart';
part 'history_filter_state.dart';

class HistoryFilterBloc extends Bloc<HistoryFilterEvent, HistoryFilterState> {
  HistoryFilterBloc() : super(HistoryFilterInitial()) {
    String sort = '';
    int categoryId = 0;

    on<HistoryFilterInitialEvent>((event, emit) {
      sort = '';
      categoryId = 0;
      emit(HistoryFilterSuccess(sort: sort, categoryId: categoryId));
    });

    on<HistoryFilterSortEvent>((event, emit) {
      sort = event.sort;
      emit(HistoryFilterSuccess(sort: sort, categoryId: categoryId));
    });

    on<HistoryFilterCategoryEvent>((event, emit) {
      categoryId = event.categoryId;
      emit(HistoryFilterSuccess(sort: sort, categoryId: categoryId));
    });
  }
}
