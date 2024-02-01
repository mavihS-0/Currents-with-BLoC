part of 'news_data_bloc.dart';

@immutable
sealed class NewsDataEvent {}

class NewsDataRequested extends NewsDataEvent{}
