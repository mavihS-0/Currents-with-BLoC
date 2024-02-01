import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'news_data_event.dart';
part 'news_data_state.dart';

class NewsDataBloc extends Bloc<NewsDataEvent, NewsDataState> {
  NewsDataBloc() : super(NewsDataInitial()) {
    on<NewsDataRequested>(_onNewsDataRequested);
  }

  void _onNewsDataRequested(NewsDataRequested event, Emitter<NewsDataState>emit) {
    emit(NewsDataLoading());
    try{

    }catch(e){
      return emit(NewsDataFetchFailure(e.toString()));
    }
  }
}
