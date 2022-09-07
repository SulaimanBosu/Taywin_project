// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, avoid_print, non_constant_identifier_names
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:taywin_project/utility/screen_size.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:taywin_project/widget/camera.dart';
import 'package:taywin_project/widget/intro_slider.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  double screenwidth = 0.0;
  double screenheight = 0.0;
  bool _isCameraPermissionGranted = false;
  String device = '';

  @override
  void initState() {
    getPermissionStatus();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // getPermissionStatus();
    super.initState();
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    await Permission.storage.request();
    var status_storage = await Permission.storage.status;
    await Permission.microphone.request();
    var microphone = await Permission.microphone.status;
    await Permission.mediaLibrary.request();
    var mediaLibrary = await Permission.mediaLibrary.status;
    await Permission.photosAddOnly.request();
    var photosAddOnly = await Permission.photosAddOnly.status;

    if (status.isGranted &&
        status_storage.isGranted &&
        microphone.isGranted &&
        mediaLibrary.isGranted &&
        photosAddOnly.isGranted) {
      log('Camera Permission: GRANTED');
      debugPrint('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
    } else {
      setState(() {
        _isCameraPermissionGranted = true;
      });
      log('Camera Permission: DENIED');
      debugPrint('Camera Permission: DENIED');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    device = ScreenSize().screenwidth(screenwidth);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 29, 89, 1),
      body: _isCameraPermissionGranted
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyStyle().showlogo(screenwidth),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        minimumSize: MaterialStateProperty.all(
                          Size(screenwidth * 0.8, 40),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => IntroSliders(
                              type: MyStyle().footmeasure,
                              screenwidth: screenwidth,
                              screenheight: screenheight,
                            ),
                          ),
                        );
                        // dialog(MyStyle().imageFootmeasure, MyStyle().detail1,
                        //     MyStyle().footmeasure);
                      },
                      child: const Text(
                        'วัดขนาดเท้า',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'FC-Minimal-Regular',
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        minimumSize: MaterialStateProperty.all(
                          Size(screenwidth * 0.8, 40),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        dialog(MyStyle().imageWaistline, MyStyle().detail2,
                            MyStyle().waistline);
                      },
                      child: const Text(
                        'วัดขนาดรอบเอว',
                        style: TextStyle(
                            fontFamily: 'FC-Minimal-Regular',
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container(),
    );
  }

  Future<void> dialog(String image, String message, String text) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          children: [
            Container(
              padding: const EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
              //     width: 200,height: 180,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                child: Image.asset(image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'ข้อควรปฎิบัติเพื่อการวัดที่ถูกต้อง',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade300),
                    foregroundColor: MaterialStateProperty.all(Colors.black87),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      if (text == MyStyle().footmeasure) {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Camera3(
                              type: text,
                              screenwidth: screenwidth,
                              screenheight: screenheight,
                            ),
                          ),
                        );
                      } else {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Camera3(
                              type: text,
                              screenwidth: screenwidth,
                              screenheight: screenheight,
                            ),
                          ),
                        );
                      }

                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ]);
                    } catch (e) {
                      print(e);
                    }
                    // Future.delayed(const Duration(milliseconds: 10), () {
                    //   setState(() {
                    //     Navigator.pop(context);
                    //   });
                    // });
                    // Navigator.pop(context);

                    // await Navigator.of(context).push(
                    //     MaterialPageRoute(
                    //       builder: (context) => const MeasureFootSize(),
                    //     ),
                    //   );
                  },
                  icon: const Icon(
                    Icons.photo_camera,
                    color: Colors.red,
                  ),
                  label: const Text('เปิดกล้อง'),
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.grey.shade300),
                    foregroundColor: MaterialStateProperty.all(Colors.black87),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.green,
                  ),
                  label: const Text('ยกเลิก'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
