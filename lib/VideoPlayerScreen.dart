import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

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
  Duration _duration = Duration(milliseconds: 100);

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
      if (dragEndDetails.primaryVelocity < 0) {
        _pageController.nextPage(duration: _duration, curve: Curves.ease);
        //_pageController.animateToPage(3, duration: _duration, curve: Curves.ease);
      } else if (dragEndDetails.primaryVelocity > 0) {
        _pageController.previousPage(duration: _duration, curve: Curves.ease);
      }
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