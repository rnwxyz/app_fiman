part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsModel> news;

  NewsLoaded(this.news);
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
