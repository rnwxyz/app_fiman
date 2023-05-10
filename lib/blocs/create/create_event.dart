part of 'create_bloc.dart';

@immutable
abstract class CreateEvent {}

class CreateInitialEvent extends CreateEvent {}

class CreateSubmitEvent extends CreateEvent {
  final TransactionModel transactionModel;

  CreateSubmitEvent(this.transactionModel);
}

class CreateSchedule extends CreateEvent {
  final ScheduleModel schedule;

  CreateSchedule(this.schedule);
}

class CreateCategoryPemasukanSelectedEvent extends CreateEvent {}

class CreateCategoryPengeluaranSelectedEvent extends CreateEvent {}
