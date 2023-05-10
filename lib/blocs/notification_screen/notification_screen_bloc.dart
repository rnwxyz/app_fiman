import 'package:app_fiman/utils/constants/contant.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';

part 'notification_screen_event.dart';
part 'notification_screen_state.dart';

class NotificationScreenBloc
    extends Bloc<NotificationScreenEvent, NotificationScreenState> {
  NotificationScreenBloc() : super(NotificationScreenInitial()) {
    on<NotificationScreenChangePage>((event, emit) {
      if (event.page == 0) {
        emit(NotificationScreenChanged(primary, accent));
      } else {
        emit(NotificationScreenChanged(accent, primary));
      }
    });
  }
}
