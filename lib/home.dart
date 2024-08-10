import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:news_app/model.dart';
import "category.dart";

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  List<String> navBarItem = [
    "Top News",
    "India",
    "politics",
    "Finacnce",
    "Health"
  ];

  bool isLoading = true;
  Future<void> getNewsByQuery(String query) async {
    try {
      // Get yesterday's date
      final yesterday = DateTime.now().subtract(Duration(days: 1));
      final formattedYesterday = getFormattedDate(yesterday);

      print(formattedYesterday);

      String url =
          "https://newsapi.org/v2/everything?q=$query&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";

      // Make the HTTP GET request
      final response = await get(Uri.parse(url));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Decode the JSON response
        Map<String, dynamic> data = jsonDecode(response.body);

        // Update the state with the new data
        setState(() {
          data["articles"].forEach((element) {
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

  getNewsofIndia() async {
    try {
      // Get yesterday's date
      final yesterday = DateTime.now().subtract(Duration(days: 1));

      final formattedYesterday = getFormattedDate(yesterday);
      String url =
          "https://newsapi.org/v2/everything?q=India&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&language=hi&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
      Response response = await get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map data = jsonDecode(response.body);
        setState(() {
          data["articles"].take(10).forEach((element) {
            try {
              NewsQueryModel newsQueryModel = new NewsQueryModel();
              newsQueryModel = NewsQueryModel.fromMap(element);
              newsModelListCarousel.add(newsQueryModel);
            } catch (e) {
              print('Error parsing article: $e');
            }
          });
          isLoading = false;
        });
      } else {
        print("Failed to load news:${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching news:$e");
    }
  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery("%E0%A4%AD%E0%A4%BE%E0%A4%B0%E0%A4%A4");
    // getNewsByQuery("%top");
    getNewsofIndia();
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
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    //Search Wala Container

                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24)),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if ((searchController.text).replaceAll(" ", "") ==
                                "") {
                              print("Blank search");
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Category(
                                          query: searchController.text)));
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                            ),
                            margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Category(query: value)));
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search Health"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: 50,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: navBarItem.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Category(query: navBarItem[index]),
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Center(
                                  child: Text(navBarItem[index],
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            );
                          })),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: 200, autoPlay: true, enlargeCenterPage: true),
                      items: newsModelListCarousel.map((instance) {
                        return Builder(builder: (BuildContext context) {
                          try {
                            return Container(
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Stack(children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset("images/bn.jpg",
                                              fit: BoxFit.fitWidth,
                                              width: double.infinity,
                                              height: double.infinity)),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12
                                                          .withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment
                                                        .bottomCenter)),
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5,
                                                    vertical: 10),
                                                child: Container(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      instance.newsHead,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))),
                                          )),
                                    ])));
                          } catch (e) {
                            print(e);
                            return Container();
                          }
                        });
                      }).toList(),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 25, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "LATEST NEWS ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 28),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
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
                                                          BorderRadius.circular(
                                                              15),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            Colors.black12
                                                                .withOpacity(0),
                                                            Colors.black
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter)),
                                                  padding: EdgeInsets.fromLTRB(
                                                      15, 15, 10, 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        newsModelList[index]
                                                            .newsHead,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        newsModelList[index]
                                                                    .newsDes
                                                                    .length >
                                                                55
                                                            ? "${newsModelList[index].newsDes.substring(0, 55)}...."
                                                            : newsModelList[
                                                                    index]
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
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Category(query: "technology")));
                                  },
                                  child: Text("SHOW MORE")),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  final List items = ["HELLO MAN", "NAMAS STAY", "DIRTY FELLOW"];
}
