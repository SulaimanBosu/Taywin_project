// @dart=2.9
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:taywin_project/widget/camera2.dart';
import 'package:taywin_project/widget/home.dart';
import 'package:taywin_project/widget/intro_slider.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    // ignore: avoid_print
    print('Error in fetching the cameras: $e');
  }
  final firstCamera = cameras.first;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget splashScreen = SplashScreenView(
      navigateRoute: const MyHome(),
     // navigateRoute: const IntroSliders(),
      pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
      duration: 5000,
      imageSize: 200,
      imageSrc: "images/logo2.png",
      // text: "Taywin Original Style",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.indigo.shade900,
        fontSize: 26.0,
      ),
      backgroundColor: Colors.white,
    );

    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
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
        home: splashScreen,
      );
    });
  }
}
