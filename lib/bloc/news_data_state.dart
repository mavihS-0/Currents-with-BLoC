part of 'news_data_bloc.dart';

@immutable
sealed class NewsDataState {}

class NewsDataInitial extends NewsDataState {}

class NewsDataFetchSuccess extends NewsDataState{
  final ApiModel apiModel;
  final int screenIndex;
  final String country;
  final String search;

  NewsDataFetchSuccess({required this.apiModel, required this.screenIndex, required this.country, required this.search});
}

class NewsDataFetchFailure extends NewsDataState{
  final String error;

  NewsDataFetchFailure(this.error);

}

class NewsDataLoading extends NewsDataState{}

