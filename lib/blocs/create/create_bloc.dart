import 'package:app_fiman/models/transaction_model.dart';
import 'package:app_fiman/repositories/database/transcation_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../models/schedule_model.dart';
import '../../repositories/database/schedule_repository.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(CreateInitial()) {
    late TransactionRepository transactionRepository;
    final ScheduleRepository scheduleRepository = ScheduleRepository();

    on<CreateInitialEvent>(
      (event, emit) {
        emit(CreateInitial());
      },
    );

    on<CreateCategoryPemasukanSelectedEvent>((event, emit) {
      emit(CategoryPemasukanSelected());
    });

    on<CreateCategoryPengeluaranSelectedEvent>((event, emit) {
      emit(CategoryPengeluaranSelected());
    });

    on<CreateSubmitEvent>(
      (event, emit) async {
        try {
          emit(CreateLoading());
          transactionRepository = TransactionRepository();
          await transactionRepository.insertTransaction(event.transactionModel);
          emit(CreateSuccess());
        } catch (e) {
          emit(CreateError(e.toString()));
        }
      },
    );

    on<CreateSchedule>(
      (event, emit) async {
        try {
          emit(CreateLoading());
          await scheduleRepository.insertSchedule(event.schedule);
          emit(CreateSuccess());
        } catch (e) {
          emit(CreateError(e.toString()));
        }
      },
    );
  }
}
