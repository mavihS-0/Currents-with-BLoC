part of 'news_data_bloc.dart';

@immutable
sealed class NewsDataEvent {}

class NewsDataRequested extends NewsDataEvent{
  final String search;
  final String country;
  final int screenIndex;
  NewsDataRequested({required this.search, required this.country, required this.screenIndex});
}

class NavBarButtonPressed extends NewsDataEvent{
  final String search;
  final String country;
  final int index;
  final ApiModel apiModel;
  NavBarButtonPressed({required this.index,required this.apiModel, required this.search, required this.country});
}

class DetailsPageRequested extends NewsDataEvent{
  final int articleIndex;
  final ApiModel apiModel;
  final String country;
  final String search;

  DetailsPageRequested({required this.articleIndex, required this.apiModel, required this.country, required this.search});
}