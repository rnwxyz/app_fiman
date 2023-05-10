part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleLoaded extends ScheduleState {
  final List<ScheduleModel> schedules;

  ScheduleLoaded(this.schedules);
}

class ScheduleError extends ScheduleState {
  final String message;

  ScheduleError(this.message);
}

class ScheduleEmpty extends ScheduleState {}
