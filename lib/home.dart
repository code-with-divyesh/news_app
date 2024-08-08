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
  getNewsByQuery(String Query) async {
    final yesterday =
        DateTime.now().subtract(Duration(days: 1)); // Get yesterday's date

    final formattedYesterday = getFormattedDate(yesterday);
    print(formattedYesterday);
    String url =
        "https://newsapi.org/v2/everything?q=$Query&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    Response response = await get(Uri.parse(url));
    print(response.body);
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

  getNewsofIndia() async {
    final yesterday =
        DateTime.now().subtract(Duration(days: 1)); // Get yesterday's date

    final formattedYesterday = getFormattedDate(yesterday);
    String url =
        "https://newsapi.org/v2/everything?q=India&from=$formattedYesterday&to=$formattedYesterday&sortBy=popularity&language=hi&apiKey=1fd412b016964f0c9dcac7117ef7ac3b";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
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
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchController.text)));
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
                              print(value);
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
                          return Container(
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
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
                                                  end: Alignment.bottomCenter)),
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              child: Container(
                                                  margin: EdgeInsets.symmetric(
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
                            }),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  onPressed: () {}, child: Text("SHOW MORE")),
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
