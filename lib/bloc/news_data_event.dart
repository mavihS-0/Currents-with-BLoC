part of 'news_data_bloc.dart';

@immutable
sealed class NewsDataEvent {}

class NewsDataRequested extends NewsDataEvent{
  final String? search;
  final String? country;
  NewsDataRequested({required this.search, required this.country});
}
