import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:multipanelvideo_app/FilmPlayer.dart';
import 'login.dart';
import 'register.dart';
import 'TrailerScreen.dart';
import 'VideoPlayerScreen.dart';
import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';

void main() async {
  final alphanumeric = RegExp(r'^S0\d+');
  print(alphanumeric.hasMatch("S01"));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(VideoPlayerApp());
}

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
  void initState() {
    super.initState();
  }

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
      Auswahlseite(_pageController)
      //VideoPlayerScreen('https://player.vimeo.com/external/475146948.hd.mp4?s=02155c3f2f4bbaf859a774a6b307bf35492f8e27&profile_id=175', _pageController)
    ];

    return PageView(children: c, controller: _pageController);
}
}

class Auswahlseite extends StatelessWidget {
  List<ImageAndTrailer> iat = new List();
  PageController _pageController;

  Auswahlseite(_pageController){
    this._pageController = _pageController;
    getData();
  }

  Future<List<ImageAndTrailer>> getData() async {

    CollectionReference filme = FirebaseFirestore.instance.collection('Filme');
    filme.get().then((value) => {
      value.docs.forEach((element) {

        iat.add(new ImageAndTrailer(new TrailerScreen(element.get("Loop"),_pageController),Image.network(element.get("Plakat")),element.id,element
        ));
      })
    });
    return iat;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: new Container(child: new Stack(children: [
      VideoPlayerScreen('https://player.vimeo.com/external/506207858.hd.mp4?s=d28f9441033be60381cf9f1d6b4ce78d78c1ceb1&profile_id=175', _pageController),
        CarouselSlider(
            options: CarouselOptions(height: 1000, viewportFraction: 0.6 , enlargeCenterPage: true, onPageChanged:(index, reason) => {
             iat.elementAt(index).trailer.play()
            }, ),
            items: iat.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Column( children: [
                    SizedBox(height: 50),
                    Flexible(fit: FlexFit.loose, child:GestureDetector(child: i.con, onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  new FilmPlayer(i.scenen, "https://player.vimeo.com/external/502661920.hd.mp4?s=ea2229cdaebea5df809dae33180132f57509f907&profile_id=175")),
                      );

                     },))
                    ,SizedBox(height: 50),
                    Flexible(fit: FlexFit.loose, child:GestureDetector(child: i.trailer, onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  new FilmPlayer(i.scenen, "https://player.vimeo.com/external/502234748.hd.mp4?s=884d53467551b607d2e4fb492c91d9dac3a9374c&profile_id=175")),
                      );
                    },)),
                    SizedBox(height: 50)
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
  String docID;
  Container con;
  List<String> scenen;

  ImageAndTrailer(trailer,img, docID,QueryDocumentSnapshot doc){
    this.trailer=trailer;
    this.img = img;
    this.docID = docID;
    con = new Container(child:img);
    final alphanumeric = RegExp(r'^S0\d+');
    scenen= new List();
    doc.data().forEach((key, value) {
      if(alphanumeric.hasMatch(key)){
        scenen.add(value);
      }
    });
    scenen.sort((a, b) => a.compareTo(b));

  }

}

