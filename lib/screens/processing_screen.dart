// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../screens/home_page.dart';

class ProcessingScreen extends StatefulWidget {
  static const routeName = "/processing-screen";
  const ProcessingScreen({Key? key}) : super(key: key);

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  bool didChangeDependencyRun = false;
  bool shouldShowLoader = true;
  late String imagePath;

  @override
  void initState() {
    print("init state called in processing screen");
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (!didChangeDependencyRun) {
      imagePath = ModalRoute.of(context)!.settings.arguments as String;
      //async code i.e fetch api goes here
      Future.delayed(Duration(seconds: 2)).then(
        (_) {
          setState(() => shouldShowLoader = false);
          showBottomSheet(context);
        },
      );
    }
    super.didChangeDependencies();
  }

  void showBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          height: 300,
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Center(
            child: Text(
              "Caption Goes Here",
              style: TextStyle(fontSize: 32),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
    //here goes audio player when playing is finished close the camera
    AudioPlayer myPlayer = AudioPlayer();
    await myPlayer.setAsset("lib/assets/audio/sample-audio-file.mp3");
    await myPlayer.play();
    Navigator.of(context).popUntil(
      ModalRoute.withName(HomePage.routeName),
    ); //when player has finished close the bottom sheet and retrun to Home Screen
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(
            File(imagePath),
          ),
          colorFilter: ColorFilter.mode(
            Colors.black54,
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Blind App"),
          centerTitle: true,
        ),
        body: shouldShowLoader
            ? Center(
                child: Image.asset("lib/assets/images/wave-animation.gif"),
              )
            : SizedBox(),
      ),
    );
  }
}
