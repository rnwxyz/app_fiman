import 'package:bloc/bloc.dart';

import '../../models/schedule_model.dart';
import '../../repositories/database/schedule_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    final ScheduleRepository scheduleRepository = ScheduleRepository();

    on<NotificationFeatch>(
      (event, emit) async {
        try {
          emit(NotificationLoading());
          final data = await scheduleRepository.getNotification();
          if (data.isEmpty) {
            emit(NotificationEmpty());
          } else {
            emit(NotificationLoaded(data));
          }
        } catch (e) {
          emit(NotificationError(e.toString()));
        }
      },
    );

    on<NotificationRead>(
      (event, emit) async {
        try {
          emit(NotificationLoading());
          await scheduleRepository.readNotification(event.id);
          final result = await scheduleRepository.getNotification();
          emit(NotificationLoaded(result));
        } catch (e) {
          emit(NotificationError(e.toString()));
        }
      },
    );
  }
}
