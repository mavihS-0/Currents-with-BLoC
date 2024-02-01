import 'dart:async';

import 'package:currents_with_bloc/data/data_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../data/models/api_model.dart';
import '../data/secret_key.dart';

part 'news_data_event.dart';
part 'news_data_state.dart';

class NewsDataBloc extends Bloc<NewsDataEvent, NewsDataState> {
  NewsDataBloc() : super(NewsDataInitial()) {
    on<NewsDataRequested>(_onNewsDataRequested);
  }

  void _onNewsDataRequested(NewsDataRequested event, Emitter<NewsDataState>emit) {
    emit(NewsDataLoading());
    try{
      // Uri url = event.country!=null && event.search != null ?
      // Uri.https('newsapi.org','/v2/everything',{'q': '${event.search}+${event.country}','apiKey':myApiKey,'sortBy':'publishedAt'}) :
      // event.search == null ? event.country!=null ?Uri.https('newsapi.org','/v2/everything',{'q': event.country,'apiKey':myApiKey,'sortBy':'publishedAt'}) :
      // Uri.https('newsapi.org','/v2/everything',{'q': 'world','apiKey':myApiKey,'sortBy':'publishedAt'}) :
      // Uri.https('newsapi.org','/v2/everything',{'q': event.search,'apiKey':myApiKey,'sortBy':'publishedAt'});
      // DataProvider().getArticles(url).then((value) => emit(NewsDataFetchSuccess(value)));
      // return;
    }catch(e){
      return emit(NewsDataFetchFailure(e.toString()));
    }
  }

  @override
  void onChange(Change<NewsDataState> change) {
    // TODO: implement onChange
    super.onChange(change);
    print('NewsDataBloc - $change');
  }
}
