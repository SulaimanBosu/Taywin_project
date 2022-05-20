// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use, avoid_print, non_constant_identifier_names
import 'dart:developer';

import 'package:appcenter/appcenter.dart';
import 'package:appcenter_analytics/appcenter_analytics.dart';
import 'package:appcenter_crashes/appcenter_crashes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taywin_project/utility/screen_size.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:taywin_project/widget/camera.dart';
import 'package:taywin_project/widget/measure_foot_size.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late double screenwidth = MediaQuery.of(context).size.width;
  late double screenheight = MediaQuery.of(context).size.height;
  bool _isCameraPermissionGranted = false;
  String device = '';

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    getPermissionStatus();
    super.initState();
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    await Permission.storage.request();
    var status_storage = await Permission.storage.status;


    if (status.isGranted && status_storage.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
    } else {
            setState(() {
        _isCameraPermissionGranted = true;
      });
      log('Camera Permission: DENIED');
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
                    FlatButton(
                      minWidth: screenwidth * 0.8,
                      color: Colors.white, // foreground
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () async {
                        dialog(MyStyle().imageFootmeasure, MyStyle().detail1,
                            MyStyle().footmeasure);
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
                    FlatButton(
                      minWidth: screenwidth * 0.8,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
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
                RaisedButton.icon(
                  onPressed: () async {
                    try {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OpenCamera(
                            type: text,
                          ),
                        ),
                      );
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.green,
                  ),
                  label: const Text('ยกเลิก'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ],
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
