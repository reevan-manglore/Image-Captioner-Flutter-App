import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import '../screens/home_page.dart';
import '../secrets.dart' as secrets;

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
  String? imageCaption;
  final FlutterTts orator = FlutterTts();

  @override
  void initState() {
    Future.wait(
      [
        orator.setLanguage("en-IN"),
        orator.setPitch(0.7),
        orator.setVolume(1.0),
      ],
    );
    super.initState();
  }

  Future<String> _imageCaptioner(String imagePath) async {
    final serverUri = Uri.parse(secrets.urlEndPoint);
    final request = http.MultipartRequest(
      "POST",
      serverUri,
    )
      ..headers["Content-Type"] = 'multipart/form-data'
      ..headers["Ocp-Apim-Subscription-Key"] = secrets.secretKey;

    final imageFile = await http.MultipartFile.fromPath("Binary", imagePath);

    request.files.add(imageFile);
    final responseSteram = await request.send();
    log("status code is ${responseSteram.statusCode}");
    final jsonResponse =
        jsonDecode(await responseSteram.stream.bytesToString());
    log("message is ${jsonResponse["description"]["captions"][0]["text"]}");
    return jsonResponse["description"]["captions"][0]["text"] as String;
  }

  @override
  void didChangeDependencies() {
    if (!didChangeDependencyRun) {
      imagePath = ModalRoute.of(context)!.settings.arguments as String;
      print(imagePath);
      _imageCaptioner(imagePath).then(
        (caption) => setState(
          () {
            imageCaption = caption;
            shouldShowLoader = false;
            showBottomSheet(context, imageCaption);
          },
        ),
      );
    }
    super.didChangeDependencies();
  }

  void showBottomSheet(BuildContext context, String? imageCaption) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Container(
          height: 300,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Center(
            child: Text(
              imageCaption ?? "Caption Goes Here",
              maxLines: 5,
              softWrap: true,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );

    await orator.speak(imageCaption ?? "caption goes here");

    await Future.delayed(const Duration(seconds: 2));
    HapticFeedback.heavyImpact();

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
          colorFilter: const ColorFilter.mode(
            Colors.black38,
            BlendMode.darken,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: shouldShowLoader
            ? Stack(children: [
                Positioned(
                  child: SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      color: Theme.of(context).primaryColor,
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: MediaQuery.of(context).viewPadding,
                          child: const Text(
                            "Image Captioner",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Image.asset("lib/assets/images/wave-animation.gif"),
                ),
              ])
            : const SizedBox(),
      ),
    );
  }
}
