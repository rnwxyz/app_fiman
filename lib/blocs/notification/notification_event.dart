part of 'notification_bloc.dart';

abstract class NotificationEvent {}

class NotificationFeatch extends NotificationEvent {}

class NotificationRead extends NotificationEvent {
  final int id;

  NotificationRead(this.id);
}
