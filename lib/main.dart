import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import './screens/home_page.dart';
import './screens/processing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final CameraDescription backCamera = cameras.first;
  runApp(MyApp(backCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;
  const MyApp(this.camera, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFA0EEFF),
      ),
      routes: {
        HomePage.routeName: (context) => HomePage(camera),
        ProcessingScreen.routeName: (context) => const ProcessingScreen(),
      },
      initialRoute: HomePage.routeName,
    );
  }
}
