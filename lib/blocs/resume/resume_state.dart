part of 'resume_bloc.dart';

abstract class ResumeState {}

class ResumeInitial extends ResumeState {}

class ResumeLoading extends ResumeState {}

class ResumeLoaded extends ResumeState {
  final int transactionSum;
  final List<ResumeModel> data;

  ResumeLoaded(this.transactionSum, this.data);
}

class ResumeError extends ResumeState {
  final String message;

  ResumeError(this.message);
}
