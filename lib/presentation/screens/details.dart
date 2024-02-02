import 'package:auto_size_text/auto_size_text.dart';
import 'package:currents_with_bloc/data/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bloc/news_data_bloc.dart';
import '../../data/constants.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsDataBloc, NewsDataState>(
  builder: (context, state) {
    ArticleModel article = (state as NewsDataFetchSuccess).apiModel.articles[state.detailsPageArticleIndex!];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
            color: SuperDarkShade,
          ),
          onPressed: (){Get.back();},
        ),
        //setting article source as app bar title
        title: article.sourceName != null ? Text(article.sourceName!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ) : null,
        centerTitle: true,
        backgroundColor: SuperLightShade,
      ),
      body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: article.urlToImage != null ? MediaQuery.of(context).size.height*0.4 : 130,
                decoration: BoxDecoration(
                  //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
                  color: SuperLightShade,
                ),
              ),
              Container(
                margin: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.057,
                      child: AutoSizeText(article.title!,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    //null check for author
                    article.author != null ? Row(children: [
                      Text('Author: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(article.author!)
                    ],) : SizedBox(height: 1,),
                    SizedBox(height: 10,),
                    //null check for image url
                    article.urlToImage != null ? Container(
                      margin: EdgeInsets.only(bottom: 10),
                      height: MediaQuery.of(context).size.height*0.24,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          article.urlToImage!,
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
                    ) : SizedBox(height: 1),
                    Row(children: [
                      Text('Published At: ', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(article.publishedAt!)
                    ],),
                    SizedBox(height: 20,),
                    Text(article.description!,
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),),
                    SizedBox(height: 20,),
                    Text(article.content.toString().length< 200 ?
                    article.content! :
                    article.content.toString().substring(0,200),
                      style: TextStyle(
                          fontSize: 17
                      ),),
                    SizedBox(height: 10,),
                    Text('Visit the website to learn more:',style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                    TextButton(
                      //function to open default browser with the url
                      onPressed: ()async {
                        String url = article.url!;
                        final uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text(article.url!,
                        style: TextStyle(
                          color: Colors.blue[900],
                          decoration: TextDecoration.underline,
                        ),),
                    )

                  ],
                ),
              )
            ],
          )
      ),
    );
  },
);
  }
}