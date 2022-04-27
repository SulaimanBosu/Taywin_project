// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taywin_project/camere.dart';
import 'package:taywin_project/utility/my_style.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late double screenwidth;
  late double screenheight;
  bool _isCameraPermissionGranted = false;
  // late Widget waistline = OpenCamera(cameras: widget.camera,type: 'waistline',);
  // late Widget footmeasure = OpenCamera(cameras: widget.camera, type: 'footmeasure',);

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      log('Camera Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
      });
      // Set and initialize the new camera
    } else {
      log('Camera Permission: DENIED');
    }
  }

  @override
  void initState() {
    getPermissionStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 29, 89, 1),
      // body: Center(
      //     child: Text(screenwidth.toString(),
      //         style: const TextStyle(color: Colors.white))),
      body: _isCameraPermissionGranted
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyStyle().showlogo(screenwidth),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        dialog(MyStyle().imageFootmeasure, MyStyle().detail1,
                            MyStyle().footmeasure);
                      },
                      label: const Text(
                        'วัดขนาดเท้า',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        dialog(MyStyle().imageWaistline, MyStyle().detail2,
                            MyStyle().waistline);
                      },
                      label: const Text(
                        'วัดขนาดรอบเอว',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            )
          : Container()
          // Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Row(),
          //       const Text(
          //         'Permission denied',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 24,
          //         ),
          //       ),
          //       const SizedBox(height: 24),
          //       ElevatedButton(
          //         onPressed: () {
          //           getPermissionStatus();
          //         },
          //         child: const Padding(
          //           padding: EdgeInsets.all(8.0),
          //           child: Text(
          //             'Give permission',
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: 24,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
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
                            cameras: widget.camera,
                            type: text,
                          ),
                        ),
                      );
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }

                    // MaterialPageRoute route = MaterialPageRoute(
                    //   builder: (context) => const OpenCamera(
                    //     camera: widget.camera;
                    //   ),
                    // );
                    // Navigator.pushAndRemoveUntil(
                    //     context, route, (route) => true);
                    // Navigator.pop(context);
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
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
