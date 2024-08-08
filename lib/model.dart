class NewsQueryModel {
  late String newsHead;
  late String newsDes;
  late String newsImg;
  late String newsUrl;

  NewsQueryModel({
    this.newsHead = "NEWS HEADLINE",
    this.newsDes = "SOME NEWS",
    this.newsImg = "SOME URL",
    this.newsUrl = "SOME URL",
  });

  factory NewsQueryModel.fromMap(Map<String, dynamic> news) {
    return NewsQueryModel(
      newsHead: news["title"] ?? "NEWS HEADLINE",
      newsDes: news["description"] ?? "SOME NEWS",
      newsImg: news["urlToImage"] ?? "SOME URL",
      newsUrl: news["url"] ?? "SOME URL",
    );
  }
}
