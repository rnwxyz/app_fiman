part of 'resume_bloc.dart';

abstract class ResumeEvent {}

class ResumeInitialEvent extends ResumeEvent {}

class ResumeFetch extends ResumeEvent {}
