import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'login.dart';
import 'register.dart';
import 'TrailerScreen.dart';
import 'VideoPlayerScreen.dart';
import 'package:firebase_core/firebase_core.dart';
void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home:HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{

  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{

  PageController _pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    List<Widget> c = [
      //Teaser
      VideoPlayerScreen('https://player.vimeo.com/external/478420658.hd.mp4?s=6f8bf4fbd005988f8ac50db2cb0856845cefceca&profile_id=175',_pageController),
      //Begrüßung
      VideoPlayerScreen('https://player.vimeo.com/external/475146519.sd.mp4?s=f727a2bf5f1586a0466d2c11ab6f65ee524c187a&profile_id=165',_pageController),
      //Nach dem Teaser
      VideoPlayerScreen('https://player.vimeo.com/external/475146749.sd.mp4?s=24bc3b95975e259841444e9b7f9a8e0c09badfb1&profile_id=165',_pageController),
      //Platzhalter für die Login Seite
      register(_pageController),
      //Auswahlseite Anleitung
      //VideoPlayerScreen('https://player.vimeo.com/external/475147068.hd.mp4?s=3baa5f1602a825b64ca360228ca23e516b825ec6&profile_id=175', _pageController),
     // Auswahlseite(_pageController)
      //VideoPlayerScreen('https://player.vimeo.com/external/475146948.hd.mp4?s=02155c3f2f4bbaf859a774a6b307bf35492f8e27&profile_id=175', _pageController)
    ];

    return PageView(children: c, controller: _pageController);
}
}

class Auswahlseite extends StatelessWidget {
  PageController _pageController;

  Auswahlseite(_pageController){
    this._pageController = _pageController;

  }

  @override
  Widget build(BuildContext context) {

    List<ImageAndTrailer> iat = new List();
    for(int i = 0; i<5;i++){
      iat.add(new ImageAndTrailer(
          new TrailerScreen('https://player.vimeo.com/external/486511656.sd.mp4?s=36911a8a987389e158baf9952e07612db30c3b18&profile_id=165', new PageController()),
          Container(
              width: 100, height: 200,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  color: Colors.amber
              ),
              child:Text('Bild $i', style: TextStyle(fontSize: 16.0))
          )));
      print(iat.elementAt(i).trailer);
    }




    return Scaffold(
      body: new Container(child: new Stack(alignment: Alignment(0,0),children: [
      VideoPlayerScreen('https://player.vimeo.com/external/506207858.hd.mp4?s=d28f9441033be60381cf9f1d6b4ce78d78c1ceb1&profile_id=175', _pageController),
        CarouselSlider(
            options: CarouselOptions(height:550, viewportFraction: 0.4 , enlargeCenterPage: true, onPageChanged:(index, reason) => {
             iat.elementAt(index).trailer.play()
            }, ),
            items: iat.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Column( children: [
                    SizedBox(height: 200),
                    Flexible(child: i.con)
                    ,SizedBox(height: 100),
                    Flexible(child: i.trailer),
                  ]
                  );
                },
              );
            }).toList())
      ]
      ),)
      );
  }
}

class ImageAndTrailer {
  Image img;
  TrailerScreen trailer;
  Container con;
  ImageAndTrailer(trailer,container){
    this.trailer=trailer;
    this.con = container;
  }
}
