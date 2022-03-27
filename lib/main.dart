import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz_Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var isLoading = false;
  late List<dynamic> quiz = [];
  var index = 0;
  var countIncorect = 0;
  var isCheckAns = false;
  bool isOnClick = false;

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        if (isLoading)
          Container(
            margin: EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.network(
                  quiz[index]["image_url"],
                  width: 250,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    for (int i = 0; i < 4; i++)
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width - 50, 50)),
                          onPressed: () {
                            checkAns(quiz[index]["choices"][i]);
                          },
                          child: Text(quiz[index]["choices"][i]),
                        ),
                      ),
                  ],
                ),
                Visibility(
                  child: isCheckAns
                      ? Text(
                          "เก่งมากครับ",
                          style: TextStyle(color: Colors.green, fontSize: 50),
                        )
                      : Text("ยังไม่ถูก ลองใหม่นะครับ",
                          style: TextStyle(color: Colors.red, fontSize: 50)),
                  visible: isOnClick,
                ),
              ],
            ),
          )
        else if (!isLoading)
          Container(
              margin: EdgeInsets.all(30),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("จบเกม",style:TextStyle(color: Colors.black, fontSize: 50) ,),
                    Text("ทายผิด $countIncorect ครั้ง ",style: TextStyle(color: Colors.black, fontSize: 50),)
                  ],
                ),
              ))
      ]),
    );
  }

  checkAns(String ans) {
    if (ans == quiz[index]["answer"] && index == quiz.length - 1) {
      setState(() {
        isCheckAns = true;
        isOnClick = false;
        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            isLoading = false;
          });
        });
      });
    } else if (ans == quiz[index]["answer"]) {
      setState(() {
        isOnClick = true;
        isCheckAns = true;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          index++;
          isOnClick = false;
        });
      });
    } else {
      countIncorect++;
      setState(() {
        isOnClick = true;
        isCheckAns = false;
      });
    }
  }

  loadQuiz() async {
    const API_URL = 'https://cpsu-test-api.herokuapp.com/quizzes';
    final response =
        await http.get(Uri.parse(API_URL), headers: {'id': '07610434'});
    Map<String, dynamic> map = json.decode(response.body);
    quiz = map["data"];
    setState(() {
      isLoading = true;
    });
  }
}
