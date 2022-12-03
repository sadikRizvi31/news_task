import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:news_task/Utils/Styles.dart';
import 'package:news_task/Utils/UIHelper.dart';

import '../Model/NewsDataModel.dart';

class Category extends StatefulWidget {


  String Query;

  Category({required this.Query});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {

  List<NewsDataModel> newsModelList = <NewsDataModel>[];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    String? url;
    if(query == 'Top News' || query == 'India')
      {
        url = "https://newsapi.org/v2/everything?country=in&sortBy=publishedAt&apiKey=45945f672b2642f0b95b48dfe755e778";
      }
    else{
      url = "https://newsapi.org/v2/everything?q=$query&sortBy=publishedAt&apiKey=45945f672b2642f0b95b48dfe755e778";
    }

    //String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=45945f672b2642f0b95b48dfe755e778";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      try{
        data["articles"].forEach((element) {
          NewsDataModel newsDataModel = new NewsDataModel();
          newsDataModel = NewsDataModel.fromMap(element);
          newsModelList.add(newsDataModel);
          setState(() {
            isLoading = false;
          });
        });
      }catch(e){print(e);}

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.Query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(widget.Query,),
                ],
              ),
              !isLoading ?
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: newsModelList.length,
                itemBuilder: (context,index){
                  try{
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 1.0,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(newsModelList[index].newsImg,height: 230,fit: BoxFit.fitHeight,width: double.infinity,),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  gradient: TextBgGradeint(),
                              ),
                              child: ListTile(
                                title: Text(newsModelList[index].newsHead,style: TextBold18(textColor: Colors.white)),
                                subtitle: Text(newsModelList[index].newsDes.length > 50 ? '${newsModelList[index].newsDes.substring(0,50)}...': newsModelList[index].newsDes,style: TextNormal12(textColor: Colors.white),),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //child: Image.network("https://img.freepik.com/free-vector/breaking-news-concept_23-2148514216.jpg?w=2000"),

                  );
                  }catch(e){ return Container();}
                },
              ) : CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
