
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:taywin_project/home.dart';
List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // ignore: avoid_print
    print('Error in fetching the cameras: $e');
  }
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
     theme: ThemeData(
  //  brightness: Brightness.dark,
    primaryColor: const Color.fromRGBO(30, 29, 89, 1),
            elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: const Color.fromRGBO(30, 29, 89, 1),
          ),
        ),
    ),
      home: MyHome(
        camera: firstCamera,
      ),
    ),
  );
}
