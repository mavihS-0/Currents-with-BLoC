import 'package:currents_with_bloc/bloc/news_data_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsDataBloc,NewsDataState>(
      listener: (context, state) {
        if(state is NewsDataInitial){
        print('NewsDataInitial');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Test Screen'),
          ),
          body: Center(
            child: Column(
              children: [
                Text('Test Screen'),
                ElevatedButton(
                  onPressed: () {
                    context.read().add<NewsDataRequested>(NewsDataRequested(search: null, country: null));
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
