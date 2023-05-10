part of 'history_filter_bloc.dart';

abstract class HistoryFilterEvent {}

class HistoryFilterInitialEvent extends HistoryFilterEvent {}

class HistoryFilterSortEvent extends HistoryFilterEvent {
  final String sort;

  HistoryFilterSortEvent(this.sort);
}

class HistoryFilterCategoryEvent extends HistoryFilterEvent {
  final int categoryId;

  HistoryFilterCategoryEvent(this.categoryId);
}
