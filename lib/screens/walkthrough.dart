import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:restaurant_ui_kit/screens/join.dart';

class Walkthrough extends StatefulWidget {
  @override
  _WalkthroughState createState() => _WalkthroughState();
}

class _WalkthroughState extends State<Walkthrough> {
  List pageInfos = [
    {
      "title": "Fresh Food and Sweets",
      "body": "Dedicated to serving delicious handmade cupcakes,"
          "cakes, cheesecakes, cookies, banana pudding and much more",
      "img": "assets/on1.png",
    },
    {
      "title": "Fast Delivery",
      "body": "Always on-time Delivery"
          "Faster than ever, always seeking to serve you happily",
      "img": "assets/on2.png",
    },
    {
      "title": "Easy Payment",
      "body": "Easy annd up-to-Date Payment Methods"
          " we always Seek the most easy and perfect way to make you satisfied.. ",
      "img": "assets/on3.png",
    },
  ];
  @override
  Widget build(BuildContext context) {
    List<PageViewModel> pages = [
      for (int i = 0; i < pageInfos.length; i++) _buildPageModel(pageInfos[i])
    ];

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: EdgeInsets.all(10.0),
          child: IntroductionScreen(
            pages: pages,
            onDone: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return JoinApp(1);
                  },
                ),
              );
            },
            onSkip: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return JoinApp(1);
                  },
                ),
              );
            },
            showSkipButton: true,
            skip: Text("Skip"),
            next: Text(
              "Next",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
            done: Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPageModel(Map item) {
    return PageViewModel(
      title: item['title'],
      body: item['body'],
      image: Image.asset(
        item['img'],
        height: 185.0,
      ),
      decoration: PageDecoration(
        titleTextStyle: TextStyle(
          fontSize: 28.0,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).accentColor,
        ),
        bodyTextStyle: TextStyle(fontSize: 15.0),
//        dotsDecorator: DotsDecorator(
//          activeColor: Theme.of(context).accentColor,
//          activeSize: Size.fromRadius(8),
//        ),
        pageColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
