import 'package:app_fiman/models/transaction_model.dart';
import 'package:app_fiman/repositories/database/transcation_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'create_event.dart';
part 'create_state.dart';

class CreateBloc extends Bloc<CreateEvent, CreateState> {
  CreateBloc() : super(CreateInitial()) {
    late TransactionRepository transactionRepository;

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
  }
}
