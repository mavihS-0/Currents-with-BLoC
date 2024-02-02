import 'dart:convert';
import 'package:currents_with_bloc/data/models/article_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:currents_with_bloc/data/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/news_data_bloc.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {

  //initializing variables
  LiquidController liquidController = LiquidController();
  List <ArticleModel> articles = [];

  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsDataBloc, NewsDataState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    if (state is! NewsDataFetchSuccess) {
      return Scaffold(
        body: Center(
          child: SpinKitFadingCube(
            color: Colors.blue,
            size: 50.0,
          ),
        ),
      );
    }
    articles = (state as NewsDataFetchSuccess).apiModel.articles;
    int totalResults = (state as NewsDataFetchSuccess).apiModel.totalResults;
    return Scaffold(
      backgroundColor: BgColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('My Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: SuperLightShade,
      ),
      //Display a sized box of height 1 if articles.length ==0 to avoid null error
      body: totalResults != 0 ? LiquidSwipe.builder(
        itemCount: totalResults,
        waveType: WaveType.liquidReveal,
        liquidController: liquidController,
        fullTransitionValue: 900,
        slideIconWidget: Icon(Icons.arrow_back_ios),
        positionSlideIcon: 0.5,
        enableSideReveal: true,
        preferDragFromRevealedArea: true,
        enableLoop: true,
        ignoreUserGestureWhileAnimating: true,
        itemBuilder: (context,index){
          ArticleModel article = articles[index];
          return Scaffold(
            backgroundColor: index%2==0 ? BgColor : SuperLightShade,
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(15),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.057,
                      child: AutoSizeText(article.title.toString(),
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    article.author != null ? Row(children: [
                      Text('Author: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(article.author.toString())
                    ],) : SizedBox(height: 1,),
                    SizedBox(height: 10,),
                    article.urlToImage != null ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: MediaQuery.of(context).size.height*0.24,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          article.urlToImage.toString(),
                          fit: BoxFit.fill,
                          //loading widget while the image loads
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
                    ) : SizedBox(height: 1),
                    Row(children: [
                      Text('Published At: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(article.publishedAt.toString())
                    ],),
                    SizedBox(height: 40,),
                    Text(article.description.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),),
                    SizedBox(height: 20,),
                    Text(article.content.toString().length <200 ?
                    article.content.toString() :
                    article.content.toString().substring(0,200),
                      style: TextStyle(
                          fontSize: 17
                      ),),
                    SizedBox(height: 10,),
                    Text('Visit the website to learn more:',style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                    TextButton(
                      onPressed: ()async {
                        String url = article.url.toString();
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(article.url.toString(),
                        style: TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.underline,
                        ),),
                    )

                  ],
                ),
              ),
            ),
          );
        },
      ) : SizedBox() ,
    );
  },
);
  }
}