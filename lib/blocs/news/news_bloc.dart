import 'package:app_fiman/repositories/api/news_repository.dart';
import 'package:app_fiman/utils/constants/contant.dart';
import 'package:bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/news_model.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsInitial()) {
    int page = 1;
    List<NewsModel> dataNews = [];
    final NewsApi newsApi = NewsApi();

    on<NewsFetch>(
      (event, emit) async {
        try {
          if (event.loadMore) {
            emit(NewsLoading());
            page++;
          } else {
            emit(NewsInitial());
            page = 1;
            dataNews = [];
          }
          final List<NewsModel> news = await newsApi.getNews(
            page: page,
            q: event.q == '' ? 'finance' : event.q,
            apiKey: newsApiKey,
          );

          dataNews.addAll(news);
          emit(NewsLoaded(dataNews));
        } catch (e) {
          emit(
            NewsError(e.toString()),
          );
        }
      },
    );

    on<NewsRedirect>(
      (event, emit) async {
        try {
          final Uri uri = Uri.parse(event.url);
          if (!await launchUrl(uri)) {
            emit(NewsError('Gagal memuat $uri'));
          }
        } catch (e) {
          emit(
            NewsError(e.toString()),
          );
        }
      },
    );
  }
}
