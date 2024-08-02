// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsQueryModel {
  late String newsHead;
  late String newsDes;
  late String newsImg;
  late String newsUrl;
  NewsQueryModel({
    this.newsHead = "NEWS HEADLINES",
    this.newsDes = "SOME NEWS",
    this.newsImg = "NEWS IMAGE",
    this.newsUrl = "NEWS URL",
  });

  factory NewsQueryModel.fromMap(Map news) {
    return NewsQueryModel(
      newsHead: news['title'],
      newsDes: news['Description'],
      newsImg: news['UrlToImage'],
      newsUrl: news['Url'],
    );
  }
}
