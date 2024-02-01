part of 'news_data_bloc.dart';

@immutable
sealed class NewsDataState {}

class NewsDataInitial extends NewsDataState {}

class NewsDataFetchSuccess extends NewsDataState{}

class NewsDataFetchFailure extends NewsDataState{
  final String error;

  NewsDataFetchFailure(this.error);

}

class NewsDataLoading extends NewsDataState{}