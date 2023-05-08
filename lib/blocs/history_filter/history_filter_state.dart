part of 'history_filter_bloc.dart';

@immutable
abstract class HistoryFilterState {}

class HistoryFilterInitial extends HistoryFilterState {}

class HistoryFilterSuccess extends HistoryFilterState {
  final String sort;
  final int categoryId;

  HistoryFilterSuccess({required this.sort, required this.categoryId});
}
