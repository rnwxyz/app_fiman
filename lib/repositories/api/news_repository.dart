import 'package:app_fiman/utils/constants/urls.dart';
import 'package:dio/dio.dart';

import '../../models/news_model.dart';

class NewsApi {
  final Dio _dio = Dio();
  final String _urls = newsUrl;

  NewsApi() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          if (e.response!.statusCode == 401) {
          } else {}
          return handler.next(e);
        },
      ),
    );
  }

  Future<List<NewsModel>> getNews({
    required int page,
    required String q,
    required String apiKey,
  }) async {
    try {
      final response = await _dio.get(
        _urls,
        queryParameters: {
          'apiKey': apiKey,
          'pageSize': 10,
          'page': page,
          'q': q,
        },
      );
      final data = List<NewsModel>.from(response.data["articles"].map(
        (e) => NewsModel.fromJson(e),
      ));
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
