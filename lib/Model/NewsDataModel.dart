
class NewsDataModel
{
  late String newsHead;
  late String newsDes;
  late String newsImg;
  late String newsUrl;
  NewsDataModel({ this.newsHead = "NEWS HEADLINE" ,  this.newsDes = "SOME NEWS" ,  this.newsImg = "SOME URL" , this.newsUrl = "SOME URL"});

  factory NewsDataModel.fromMap(Map news)
  {
    return NewsDataModel(
        newsHead: news["title"],
        newsDes: news["description"],
        newsImg: news["urlToImage"],
        newsUrl: news["url"]
    );
  }
}