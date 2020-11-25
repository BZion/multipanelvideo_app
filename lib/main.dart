import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen('https://player.vimeo.com/external/475146519.sd.mp4?s=f727a2bf5f1586a0466d2c11ab6f65ee524c187a&profile_id=165'),
    );
  }
}


class VideoPlayerScreen extends StatefulWidget {
  String _link;
  VideoPlayerScreen(_link) {
    this._link=_link;
  }

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(_link);

}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  bool _isVisible = false;
  String _link;

  _VideoPlayerScreenState(_link){
    this._link=_link;
  }

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(_link,
    )..initialize().then((_){setState(() {

    });});
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

    return Scaffold(
      body: Center(
        child: GestureDetector(onTap: onTap,onPanUpdate: onPanUpdate,
          child:
          Stack(children:[VideoPlayer(_controller, ),Center(
              child:
              ButtonTheme(
                  height: 100.0,
                  minWidth: 200.0,
                  child: Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: _isVisible,
                      child: FlatButton(
                        padding: EdgeInsets.all(60.0),
                        color: Colors.transparent,
                        textColor: Colors.white,
                        onPressed: () {
                        },
                        child: Icon(
                          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 60.0,
                        ),
                      )))
          ) ]),
        ),
      ),
    );
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
  onPanUpdate(details) {
    // swiping right
    if (details.delta.dx > 0) {
      print("swiping right");
     /* _controller=VideoPlayerController.network('https://player.vimeo.com/external/475146519.sd.mp4?s=f727a2bf5f1586a0466d2c11ab6f65ee524c187a&profile_id=165',   )..initialize().then((_){setState(() {

      });});*/
      // swiping left
    }else if (details.delta.dx < 0){
      print("swiping left");
    /*  _controller=VideoPlayerController.network('https://player.vimeo.com/external/475146619.sd.mp4?s=9e8126ba00891010a4f32c93b8ebf79f55d01c4e&profile_id=165',   )..initialize().then((_){setState(() {

      });});*/
    }
  }
}
/*
*
* child: _controller.value.initialized
                   ? AspectRatio(
                 aspectRatio: _controller.value.aspectRatio,
                      child:     Icon(Icons.play_arrow) ,

*
*     return GestureDetector(onTap: onTap,child: Container(

             child: Icon(Icons.play_arrow) ,

       )
       );
*
* VideoPlayer(_controller),Positioned( // will be positioned in the top right of the container
          top: 0,
          right: 0,
          child: Icon(
          Icons.help,
        ),
        )])
* */
