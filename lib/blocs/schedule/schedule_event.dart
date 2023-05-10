part of 'schedule_bloc.dart';

@immutable
abstract class ScheduleEvent {}

class ScheduleFeatch extends ScheduleEvent {}

class ScheduleAdd extends ScheduleEvent {
  final ScheduleModel schedule;

  ScheduleAdd(this.schedule);
}

class ScheduleDelete extends ScheduleEvent {
  final int id;

  ScheduleDelete(this.id);
}
