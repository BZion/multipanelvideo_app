import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TrailerScreen extends StatefulWidget {

String _link;
PageController _pageController;
VideoPlayerController _controller;
_TrailerScreenState _state;
TrailerScreen(_link, _pageController) {
  print("TrailerScreen");
  this._link=_link;
  this._pageController = _pageController;
  this._controller = VideoPlayerController.network(_link);
}

play(){
_state.play();
}


@override
_TrailerScreenState createState()  {
  _state = _TrailerScreenState(_link,_pageController,_controller);
  return _state;
}
}

class _TrailerScreenState extends State<TrailerScreen> {
  VideoPlayerController _controller;
  PageController _pageController;
  Future<void> _initializeVideoPlayerFuture;
  String _link;

  play(){
    setState(() {
        _controller.play();
    });
  }




  _TrailerScreenState(_link,_pageController,_controller){
    this._link=_link;
    this._pageController = _pageController;
    //  this._controller=_controller;
  }

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    print("initState");
    if(_controller == null){
      print("_controller==null");
      _controller = VideoPlayerController.network(_link,
      )..initialize().then((_){setState(() {

      });});
    }
  }

  @override
  void dispose() {
    print("Disposing");
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:VideoPlayer(_controller));
  }
}