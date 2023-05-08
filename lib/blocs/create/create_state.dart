part of 'create_bloc.dart';

@immutable
abstract class CreateState {}

class CreateInitial extends CreateState {}

class CreateLoading extends CreateState {}

class CreateSuccess extends CreateState {}

class CreateError extends CreateState {
  final String message;

  CreateError(this.message);
}

class CategoryPemasukanSelected extends CreateState {}

class CategoryPengeluaranSelected extends CreateState {}
