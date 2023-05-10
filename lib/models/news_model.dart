class NewsModel {
  late String author;
  late String title;
  late DateTime publishedAt;
  late String url;
  late String urlToImage;

  NewsModel({
    required this.author,
    required this.title,
    required this.publishedAt,
    required this.url,
    required this.urlToImage,
  });

  NewsModel.fromJson(Map<String, dynamic> map) {
    author = map['author'] ?? '';
    title = map['title'] ?? '';
    publishedAt = DateTime.parse(map['publishedAt']);
    url = map['url'];
    urlToImage = map['urlToImage'] ?? '';
  }
}
