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
    on<NavBarButtonPressed>(_onNavBarButtonPressed);
  }

  void _onNavBarButtonPressed(NavBarButtonPressed event, Emitter<NewsDataState>emit) {
    return emit(NewsDataFetchSuccess(apiModel: event.apiModel, screenIndex: event.index, country: event.country, search: event.search));
  }

  Future<void> _onNewsDataRequested(NewsDataRequested event, Emitter<NewsDataState>emit) async {
    emit(NewsDataLoading());
    try{
      Uri url = event.country!='null' && event.search != 'null' ?
      Uri.https('newsapi.org','/v2/everything',{'q': '${event.search}+${event.country}','apiKey':myApiKey,'sortBy':'publishedAt'}) :
      event.search == 'null' ? event.country!='null' ?Uri.https('newsapi.org','/v2/everything',{'q': event.country,'apiKey':myApiKey,'sortBy':'publishedAt'}) :
      Uri.https('newsapi.org','/v2/everything',{'q': 'world','apiKey':myApiKey,'sortBy':'publishedAt'}) :
      Uri.https('newsapi.org','/v2/everything',{'q': event.search,'apiKey':myApiKey,'sortBy':'publishedAt'});
      ApiModel apiModel = await DataProvider().getArticles(url);
      emit(NewsDataFetchSuccess(apiModel: apiModel, screenIndex: event.screenIndex, country: event.country, search: event.search));
      return;
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
