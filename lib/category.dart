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

  Future<void> getNewsByQuery(String query) async {
    try {
      // Get yesterday's date
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      final formattedYesterday = getFormattedDate(yesterday);
      String url;

      // Determine the URL based on the query
      switch (query.toLowerCase()) {
        case "top news":
          url =
              "https://newsapi.org/v2/everything?q=top&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
          break;
        case "politics":
          url =
              "https://newsapi.org/v2/everything?q=india%20politics&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
          break;
        case "finance":
          url =
              "https://newsapi.org/v2/everything?q=business&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
          break;
        case "health":
          url =
              "https://newsapi.org/v2/everything?q=health&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
          break;
        case "india":
          url =
              "https://newsapi.org/v2/everything?q=India&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&language=hi&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
          break;
        case "technology":
          url =
              "https://newsapi.org/v2/everything?q=technology&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
          break;
        default:
          url =
              "https://newsapi.org/v2/everything?q=$query&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
      }

      // Make the HTTP GET request
      final response = await get(Uri.parse(url));

      // Check for successful response
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        setState(() {
          data["articles"].take(10).forEach((element) {
            try {
              NewsQueryModel newsQueryModel = NewsQueryModel.fromMap(element);
              newsModelList.add(newsQueryModel);
            } catch (e) {
              print('Error parsing article: $e');
            }
          });

          // Update the loading state
          isLoading = false;
        });
      } else {
        print('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
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
                          try {
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
                                          borderRadius:
                                              BorderRadius.circular(15),
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
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter)),
                                              padding: EdgeInsets.fromLTRB(
                                                  15, 15, 10, 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    newsModelList[index]
                                                        .newsHead,
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
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        }),
                  ],
                ),
              ),
            ),
    );
  }
}
