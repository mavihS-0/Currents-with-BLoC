import 'dart:convert';

import 'package:currents_with_bloc/data/constants.dart';
import 'package:currents_with_bloc/data/models/article_model.dart';
import 'package:currents_with_bloc/presentation/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:country_picker/country_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../bloc/news_data_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocBuilder<NewsDataBloc, NewsDataState>(
  builder: (context, state) {
    if(state is NewsDataFetchFailure){
      return Scaffold(
        body: Center(
          child: Text('Error: ${state.error}'),
        ),
      );
    }
    return Scaffold(
          backgroundColor: BgColor,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            //widget to reload the api service
            child: LiquidPullToRefresh(
              onRefresh: () async{
                context.read<NewsDataBloc>().add(NewsDataRequested(search: state.search,country: state.country, screenIndex: 0));
                },
              showChildOpacityTransition: false,
              backgroundColor: LightShade,
              child: Container(
                padding: EdgeInsets.only(left: 20,right: 20,top: 30),
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.06,
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Search',
                            filled: true,
                            fillColor: SuperLightShade,
                            contentPadding: EdgeInsets.all(10),
                            prefixIcon: Icon(Icons.search,color: TextColor,size: MediaQuery.of(context).size.height*0.025,),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: SuperLightShade),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: SuperLightShade),
                            )
                        ),
                        style: TextStyle(
                            color: TextColor,
                            fontSize: MediaQuery.of(context).size.height*0.02
                        ),
                        onSubmitted: (value) {
                          //print(value);
                          context.read<NewsDataBloc>().add(NewsDataRequested(search: value,country: 'null', screenIndex: 0));
                        },
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text('Top Stories',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TextColor,
                            fontSize: MediaQuery.of(context).size.height*0.025,
                          ),),
                        ),
                        //Filter country button
                        Container(
                          margin: EdgeInsets.symmetric(vertical:5, horizontal: 5),
                          padding: EdgeInsets.all(4),
                          height: MediaQuery.of(context).size.height*0.05,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: LightShade,
                          ),
                          child: TextButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Country',style: TextStyle(color: TextColor),),
                                Icon(Icons.filter_alt_outlined,color: TextColor,),
                              ],
                            ),
                            onPressed: (){
                              showCountryPicker(
                                context: context,
                                onSelect: (Country country)async {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context)=> Center(child: SpinKitThreeBounce(
                                      size: 30,
                                      color: DarkShade,
                                    )),
                                  );
                                  String selectedCountry= await country.name;
                                  Get.back();
                                  context.read<NewsDataBloc>().add(NewsDataRequested(search: 'null',country: selectedCountry, screenIndex: 0));
                                },
                                countryListTheme: CountryListThemeData(
                                  borderRadius: BorderRadius.circular(30),
                                  backgroundColor: SuperLightShade,
                                  inputDecoration: InputDecoration(
                                      hintText: 'Search',
                                      filled: true,
                                      fillColor: LightShade,
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Icon(Icons.search,color: TextColor,size: MediaQuery.of(context).size.height*0.025,),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: SuperLightShade),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide(color: SuperLightShade),
                                      )
                                  ),
                                ),
                              );
                            },

                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1,thickness: 2,endIndent: MediaQuery.of(context).size.width*0.67, indent: 12,color: TextColor,),
                    SizedBox(height: 20,),
                    Container(
                      height: MediaQuery.of(context).size.height*0.68,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: (state as NewsDataFetchSuccess).apiModel.totalResults,
                        shrinkWrap: true,
                        itemBuilder: (_,i){
                          ArticleModel article = state.apiModel.articles[i];
                          return GestureDetector(
                            onTap: (){
                              context.read<NewsDataBloc>().add(DetailsPageRequested(articleIndex: i, apiModel: state.apiModel, country: state.country, search: state.search));
                              Get.to(()=>const DetailsPage());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height*0.3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: SuperLightShade,
                              ),
                              //null check for image url
                              child: article.urlToImage != null ? Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.2,
                                    width: MediaQuery.of(context).size.width,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        article.urlToImage.toString(),
                                        fit: BoxFit.fill,
                                        loadingBuilder: (BuildContext context, Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                  loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.network('https://www.pngall.com/wp-content/uploads/4/Exclamation-Mark.png',
                                                  height: MediaQuery.of(context).size.height*0.1,
                                                ),
                                                SizedBox(height: 10,),
                                                Text('Error loading image')
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.06,
                                    child: AutoSizeText(article.title.toString(),
                                      //maxLines: 2,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),),
                                  )
                                ],
                              ) :
                              Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.1,
                                    child: AutoSizeText(article.title.toString(),
                                      //maxLines: 3,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    child: AutoSizeText(article.description.toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        );
  },
)
    );
  }
}