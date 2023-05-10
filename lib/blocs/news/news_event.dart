part of 'news_bloc.dart';

abstract class NewsEvent {}

class NewsFetch extends NewsEvent {
  final bool loadMore;
  final String q;

  NewsFetch({required this.loadMore, required this.q});
}

class NewsRedirect extends NewsEvent {
  final String url;

  NewsRedirect(this.url);
}
