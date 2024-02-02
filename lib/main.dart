import 'package:currents_with_bloc/presentation/screens/splashScreen.dart';
import 'package:currents_with_bloc/presentation/util/navBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/news_data_bloc.dart';
import 'data/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsDataBloc(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Currents',
        //declaring Theme Data
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey)
              .copyWith(background: BgColor),
          fontFamily: GoogleFonts
              .lato()
              .fontFamily,
        ),
        //splash screen when opening app
        home: SplashPage(),
      ),
    );
  }
}
