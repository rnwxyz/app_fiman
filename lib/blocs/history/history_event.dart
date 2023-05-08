part of 'history_bloc.dart';

abstract class HistoryEvent {}

class HistoryInitialEvent extends HistoryEvent {}

class HistoryFetchEvent extends HistoryEvent {
  final bool loadMore;
  final String search;
  String? sort;
  int? categoryId;

  HistoryFetchEvent(
      {required this.loadMore,
      required this.search,
      this.sort,
      this.categoryId});
}

class HistoryDeleteEvent extends HistoryEvent {
  final int id;

  HistoryDeleteEvent(this.id);
}
