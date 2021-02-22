import 'package:flutter/cupertino.dart';
import 'package:multipanelvideo_app/VideoPlayerScreen.dart';

class FilmPlayer extends StatefulWidget{

  List<String> scenen;
  String zusatz;
  FilmPlayer(List<String> l,String z){
    this.scenen = l;
    this.zusatz = z;
  }

  FilmPlayerState createState() => FilmPlayerState(scenen,zusatz);
}

class FilmPlayerState extends State<FilmPlayer>{
  PageController _pageController = PageController(initialPage: 1);
  List<String> scenen;
  List<Widget> scenenPlayer = new List();
  String zusatz;

  FilmPlayerState(List<String> l,String z){
    this.scenen = l;
    this.zusatz = z;
    scenen.forEach((element) {
      scenenPlayer.add(new VideoPlayerScreen(element, _pageController));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int page = 0;
    PageView scenenPageView = PageView(children: scenenPlayer, controller: _pageController);
    return  PageView(
  controller: PageController(initialPage: 2),
  scrollDirection: Axis.vertical,
  children: [new VideoPlayerScreen(zusatz, _pageController), scenenPageView,],
  );
}
}
