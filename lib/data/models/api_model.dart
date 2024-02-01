import 'package:currents_with_bloc/data/models/article_model.dart';

class ApiModel{
  String status;
  int totalResults;
  List<ArticleModel> articles;

  ApiModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });
}