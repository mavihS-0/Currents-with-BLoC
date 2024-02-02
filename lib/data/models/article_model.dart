class ArticleModel{
  String? title;
  String? author;
  String? publishedAt;
  String? description;
  String? content;
  String? url;
  String? urlToImage;
  String? sourceName;

  ArticleModel({
    required this.title,
    required this.author,
    required this.publishedAt,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
    required this.sourceName
  });
}