import 'dart:convert';

import 'package:currents_with_bloc/data/models/api_model.dart';
import 'package:http/http.dart';

import 'models/article_model.dart';

class DataProvider{

  Future<ApiModel> getArticles(Uri url) async {
    ApiModel apiModel = ApiModel(status: '', totalResults: 0, articles: []);
    var response = await get(url);
    if(response.statusCode==200){
      var jsonResponse =jsonDecode(response.body) as Map <String, dynamic>;
      for (var element in jsonResponse['articles']) {
        apiModel.articles.add(ArticleModel(
          title: element['title'],
          publishedAt: element['publishedAt'],
          author: element['author'],
          content: element['content'],
          description: element['description'],
          url: element['url'],
          urlToImage: element['urlToImage']
        ));
      }
      apiModel.status = jsonResponse['status'];
      apiModel.totalResults = apiModel.articles.length;

      return apiModel;
    }
    else{
      //displaying error message
      throw Exception('Request failed with error code ${response.statusCode}');
    }

  }
}