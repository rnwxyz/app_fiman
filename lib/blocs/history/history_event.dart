part of 'history_bloc.dart';

abstract class HistoryEvent {}

class HistoryInitialEvent extends HistoryEvent {}

class HistoryFetchEvent extends HistoryEvent {}
