import 'package:app_fiman/repositories/database/schedule_repository.dart';
import 'package:bloc/bloc.dart';

import '../../models/schedule_model.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc() : super(ScheduleInitial()) {
    final ScheduleRepository scheduleRepository = ScheduleRepository();

    on<ScheduleFeatch>(
      (event, emit) async {
        try {
          emit(ScheduleLoading());
          final data = await scheduleRepository.getSchedule();
          if (data.isEmpty) {
            emit(ScheduleEmpty());
          } else {
            emit(ScheduleLoaded(data));
          }
        } catch (e) {
          emit(ScheduleError(e.toString()));
        }
      },
    );

    on<ScheduleDelete>(
      (event, emit) async {
        try {
          emit(ScheduleLoading());
          await scheduleRepository.deleteSchedule(event.id);
          final result = await scheduleRepository.getSchedule();
          emit(ScheduleLoaded(result));
        } catch (e) {
          emit(ScheduleError(e.toString()));
        }
      },
    );
  }
}
