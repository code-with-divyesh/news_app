import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart";
import 'package:intl/intl.dart';
import "package:news_app/model.dart";

class Category extends StatefulWidget {
  String query;
  Category({required this.query});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;
  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future getNewsByQuery(String Query) async {
    final yesterday =
        DateTime.now().subtract(Duration(days: 1)); // Get yesterday's date

    final formattedYesterday = getFormattedDate(yesterday);
    String url = "";
    if (Query == "Top News") {
      url =
          "https://newsapi.org/v2/everything?q=top&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    } else if (Query == "politics") {
      url =
          "https://newsapi.org/v2/everything?q=india%20politics&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    } else if (Query == "Finacnce") {
      url =
          "https://newsapi.org/v2/everything?q=business&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    } else if (Query == "Health") {
      url =
          "https://newsapi.org/v2/everything?q=health&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    } else if (Query == "India") {
      url =
          "https://newsapi.org/v2/everything?q=India&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&language=hi&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    } else if (Query == "technology") {
      url =
          "https://newsapi.org/v2/everything?q=technology&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    } else {
      url =
          "https://newsapi.org/v2/everything?q=$Query&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    }

    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("NEWS APP"),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              widget.query,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 28),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: newsModelList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                elevation: 1.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.asset(
                                          "images/bn.jpg", // newsModelList[index].newsImg
                                          fit: BoxFit.fitWidth,
                                          height: 230,
                                          width: double.infinity,
                                        )),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            padding: EdgeInsets.fromLTRB(
                                                15, 15, 10, 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  newsModelList[index].newsHead,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  newsModelList[index]
                                                              .newsDes
                                                              .length >
                                                          55
                                                      ? "${newsModelList[index].newsDes.substring(0, 55)}...."
                                                      : newsModelList[index]
                                                          .newsDes,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                )
                                              ],
                                            )))
                                  ],
                                )),
                          );
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
