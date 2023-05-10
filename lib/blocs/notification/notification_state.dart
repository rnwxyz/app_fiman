part of 'notification_bloc.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<ScheduleModel> schedules;

  NotificationLoaded(this.schedules);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}

class NotificationEmpty extends NotificationState {}
