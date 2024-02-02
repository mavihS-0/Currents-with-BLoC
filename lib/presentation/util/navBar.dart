import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../bloc/news_data_bloc.dart';
import '../../data/constants.dart';
import '../screens/feed.dart';
import '../screens/home.dart';


class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {

  //declaring variables
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  );

  //setting initial index as My Feed page
  int index = 1;
  final screens = [
    HomePage(),
    FeedPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsDataBloc, NewsDataState>(
      builder: (context, state) {
        if(state is NewsDataInitial){
          context.read<NewsDataBloc>().add(NewsDataRequested(search: 'world', country: 'null', screenIndex: 1));
        }
        if (state is NewsDataLoading || state is NewsDataInitial) {
          return Scaffold(
            body: Center(
              child: SpinKitFadingCube(
                color: DarkShade,
                size: 50.0,
              ),
            ),
          );
        }
        if (state is NewsDataFetchFailure){
          return Scaffold(
            body: Center(
              child: Text('Error: ${state.error}'),
            ), 
          );
        }
        return Scaffold(
          body: screens[(state as NewsDataFetchSuccess).screenIndex],
          bottomNavigationBar: SnakeNavigationBar.color(
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.circle,
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
            shape: bottomBarShape,

            ///configuration for SnakeNavigationBar.color
            backgroundColor: DarkShade,
            snakeViewColor: SuperLightShade,
            selectedItemColor: TextColor,
            unselectedItemColor: Colors.white,

            currentIndex: state.screenIndex,
            onTap: (i) {
              context.read<NewsDataBloc>().add(NavBarButtonPressed(index: i, apiModel: state.apiModel, search: state.search, country: state.country));
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book_outlined), label: 'Feed'),
            ],
          ),
        );
      },
    );
  }
}