import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
      Container(child: Text("Login Seite")),
      //Auswahlseite Anleitung
      //VideoPlayerScreen('https://player.vimeo.com/external/475147068.hd.mp4?s=3baa5f1602a825b64ca360228ca23e516b825ec6&profile_id=175', _pageController),
      Auswahlseite(_pageController)
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
    return Scaffold(
      body: new Container(child: new Stack(alignment: Alignment(0,0),children: [
      VideoPlayerScreen('https://player.vimeo.com/external/506207858.hd.mp4?s=d28f9441033be60381cf9f1d6b4ce78d78c1ceb1&profile_id=175', _pageController),
        CarouselSlider(
            options: CarouselOptions(height: 175, viewportFraction: 0.3 , enlargeCenterPage: true ),
            items: [1,2,3,4,5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: 100,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          color: Colors.amber
                      ),
                      child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                  );
                },
              );
            }).toList())
      ]
      ),)
      );
  }
  
}


class VideoPlayerScreen extends StatefulWidget {
  String _link;
  PageController _pageController;
  VideoPlayerController _controller;
  VideoPlayerScreen(_link, _pageController) {
    print("VideoPlayerScreen");
    this._link=_link;
    this._pageController = _pageController;
    this._controller = VideoPlayerController.network(_link);
  }

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(_link,_pageController,_controller);

}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  PageController _pageController;
  Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = false;
  String _link;
  Duration _duration = Duration(milliseconds: 200);

  _VideoPlayerScreenState(_link,_pageController,_controller){
    this._link=_link;
    this._pageController = _pageController;
  //  this._controller=_controller;
    print("VideoPlayerScreenState");
  }

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    print("initState");
    if(_controller==null){
      print("_controller==null");
      _controller = VideoPlayerController.network(_link,
    )..initialize().then((_){setState(() {

    });});
    }
    _controller.play();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(  onHorizontalDragEnd: (dragEndDetails) {
      print("onHorizontalDragEnd");
      print("_pageController.page"+_pageController.page.toString());
      if (dragEndDetails.primaryVelocity < 0) {
        // Page forwards
        print('Move page forwards');
        _pageController.nextPage(duration: _duration, curve: Curves.ease);
        //_pageController.animateToPage(3, duration: _duration, curve: Curves.ease);
      } else if (dragEndDetails.primaryVelocity > 0) {
        // Page backwards
        print('Move page backwards');
        _pageController.previousPage(duration: _duration, curve: Curves.ease);
      }
    },onVerticalDragUpdate: (dragEndDetails){
        print('Additional Content');
    },onTap: onTap,
    child:VideoPlayer(_controller));
  }
  onTap(){
    setState(() {
      // If the video is playing, pause it.
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // If the video is paused, play it.
        _controller.play();
      }
    });
  }

}
