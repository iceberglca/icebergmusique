import 'dart:async';

import 'package:flutter/material.dart';
import 'music.dart';
import 'package:audioplayers/audioplayers.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Iceberg Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Iceberg Music'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
List<Music> maListeDeMusiques= [
  new Music('Theme Swift','Codabee','assets/un.jpg','https://codabee.com/wp-content/uploads/2018/06/un.mp3'),
  new Music('Theme flutter','Codabee','assets/deux.jpg','https://codabee.com/wp-content/uploads/2018/06/deux.mp3'),
];
Music maMusiqueActuelle;
Duration position = new Duration(seconds: 0);
Duration duree = new Duration(seconds: 10);
PlayerState statut = PlayerState.stopped;
AudioPlayer audioPlayer;
StreamSubscription positionSub;
StreamSubscription stateSubscription;
@override
void initState(){
  super.initState();
  maMusiqueActuelle=maListeDeMusiques[0];
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[900],
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Card(
              elevation: 9.0,
              child: new Container(
                width: MediaQuery.of(context).size.height/2.5,
                child: new Image.asset(  maMusiqueActuelle.imagePath),
              ),
            ),
            texteAvecStyle(maMusiqueActuelle.title, 1.5),
            texteAvecStyle(maMusiqueActuelle.artiste, 1.0),
            new Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bouton(Icons.fast_rewind,30.0, ActionMusic.rewind),
                bouton(Icons.play_arrow,30.0, ActionMusic.play),
                bouton(Icons.fast_forward,30.0, ActionMusic.forward),

              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                texteAvecStyle('0.0', 0.8),
                texteAvecStyle('0.22', 0.8),
              ],
            ),
            new Slider(
                value: position.inSeconds.toDouble(),
                min:0.0,
                max: 30.0,
                inactiveColor: Colors.white,
                activeColor: Colors.red,
                onChanged: (double d){
                  setState(() {
                    Duration nouvelleDuration =new Duration(seconds: d.toInt())
                    position=nouvelleDuration;
                  });
                }
            )
          ],
        ),
      ),
    );
  }
  IconButton bouton(IconData icone,double taille,ActionMusic action){

  return new IconButton(
    iconSize: taille,
      color: Colors.white,
      icon: new Icon(icone),
      onPressed: (){
        switch(action){
          case ActionMusic.play:
            print('play');
            break;
            case ActionMusic.pause:
            print('pause');
            break;
            case ActionMusic.forward:
            print('foward');
            break;
            case ActionMusic.rewind:
            print('rewind');
            break;
        }
      }
      );
  }
  Text texteAvecStyle(String data,double scale){
  return new Text(
    data,
    textScaleFactor: scale,
    textAlign: TextAlign.center,
    style:  new TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontStyle: FontStyle.italic
    ),
  );
  }
  void configurationAudioPlayer(){
  audioPlayer =new AudioPlayer();
  positionSub= audioPlayer.onAudioPositionChanged.listen(
      (pos)=>setState(()=>position = pos)
  );
  stateSubscription= audioPlayer.onPlayerStateChanged.listen((state){
    if(state == AudioPlayerState.PLAYING){
      setState((){
        duree = audioPlayer.duration;

      });
    }else if(state==AudioPlayerState.STOPPED){
      setState((){
        statut = PlayerState.stopped;

      });
    }
  }, onError:(message){
    print('erreur:' $message);
    setState(() {
      statut=PlayerState.stopped;
      duree =new Duration(seconds: 0);
      position= new Duration(seconds: 0);
    });
  }
  );
  }
}
enum ActionMusic{
  play,
  pause,
  rewind,
  forward
}
enum PlayerState{
  playing,
  stopped,
  paused
}
