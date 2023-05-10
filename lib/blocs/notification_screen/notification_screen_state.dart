part of 'notification_screen_bloc.dart';

@immutable
abstract class NotificationScreenState {}

class NotificationScreenInitial extends NotificationScreenState {}

class NotificationScreenChanged extends NotificationScreenState {
  final Color colorNotif;
  final Color colorSchedule;

  NotificationScreenChanged(this.colorNotif, this.colorSchedule);
}
