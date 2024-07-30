import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "News App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(24.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              // decoration: ,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {}
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(2, 0, 7, 0),
                      child: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        print(value);
                      },
                      decoration: InputDecoration(
                          hintText: "Seach any news", border: InputBorder.none),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
