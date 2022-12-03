import 'dart:convert';

import 'package:news_task/Utils/Styles.dart';

import '../Views/Category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Utils/UIHelper.dart';
import '../Model/NewsDataModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

import 'NewsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController searchController = TextEditingController();
  List<NewsDataModel> newsModelList = <NewsDataModel>[];
  List<NewsDataModel> newsModelListCarousel = <NewsDataModel>[];
  bool isLoading = true;
  List<String> navBarItem = ['Top News','health','business','entertainment','science','technology'];
  String? format;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime now = DateTime.now();
    format =  DateFormat('yyyy-MM-dd').format(now);
    getNewsByQuery("world");
    getNewsByProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 15),
              padding: EdgeInsets.fromLTRB(10,0,10,0),
              child: TextField(
                style: TextNormal18(),
                decoration: InputDecoration(

                  prefixIcon: Icon(Icons.search_outlined,color: Colors.black,),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(55)),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(55)),
                    borderSide: BorderSide(color: Colors.black, width: 2.0),
                  ),
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.black,),
                ),
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: (value){
                  if(value == ""){
                    print("Blank Search");
                  }
                  else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: value)));
                  }
                }
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 15),
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: navBarItem.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: ()
                    {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: navBarItem[index])));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(child: Text(navBarItem[index],style: TextStyle(fontFamily: 'Mont-Regular'),)),
                    ),
                  );
                }
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: !isLoading ? CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,

                ),
                items: newsModelListCarousel.map((instance) {
                  return Builder(
                    builder: (context){
                      try{
                        return Container(
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage(instance.newsUrl)));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(instance.newsImg,width: 300,fit: BoxFit.fitHeight,height: double.infinity,),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: EdgeInsets.only(left: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          gradient: TextBgGradeint(),
                                      ),
                                      child: Text(
                                        instance.newsHead,
                                        style: TextBold14(textColor: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }catch(e){return Container();}

                    },
                  );
                }).toList(),
              ) : CircularProgressIndicator(),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Latest News",style: TextBold18(),),
                      ElevatedButton(onPressed: (){},
                          child: Text("More.."),
                      )
                    ],
                  ),
                  if (!isLoading) ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: newsModelList.length,
                    itemBuilder: (context,index){
                      try{
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage(newsModelList[index].newsUrl)));
                            },
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
                                        title: Text(newsModelList[index].newsHead,style: TextBold18(textColor: Colors.white),
                                        ),
                                        subtitle: Text(newsModelList[index].newsDes.length > 50 ? '${newsModelList[index].newsDes.substring(0,50)}...': newsModelList[index].newsDes,style: TextNormal12(textColor: Colors.white)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          //child: Image.network("https://img.freepik.com/free-vector/breaking-news-concept_23-2148514216.jpg?w=2000"),

                        );
                      }catch(e){ return Container();}

                    },
                  ) else CircularProgressIndicator(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  final List Items = [Colors.yellow,Colors.deepOrange,Colors.lightBlueAccent];

  getNewsByQuery(String query) async {
    String url = "https://newsapi.org/v2/everything?q=$query&from=$format&sortBy=publishedAt&apiKey=45945f672b2642f0b95b48dfe755e778";
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

  getNewsByProvider() async {
    //String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=45945f672b2642f0b95b48dfe755e778";
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=45945f672b2642f0b95b48dfe755e778";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      try{
        data["articles"].forEach((element) {
          NewsDataModel newsDataModel = new NewsDataModel();
          newsDataModel = NewsDataModel.fromMap(element);
          newsModelListCarousel.add(newsDataModel);
          setState(() {
            isLoading = false;
          });

        });
      }catch(e){print(e);}

    });

  }

}
