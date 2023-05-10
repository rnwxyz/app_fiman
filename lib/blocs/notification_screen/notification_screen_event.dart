part of 'notification_screen_bloc.dart';

abstract class NotificationScreenEvent {}

class NotificationScreenChangePage extends NotificationScreenEvent {
  final int page;

  NotificationScreenChangePage(this.page);
}
