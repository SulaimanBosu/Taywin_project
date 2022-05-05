// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_unnecessary_containers, camel_case_types, avoid_print, unused_element, sized_box_for_whitespace

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taywin_project/utility/screen_size.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taywin_project/widget/measurement_results.dart';

class OpenCamera extends StatefulWidget {
  const OpenCamera({
    Key? key,
    required this.cameras,
    required this.type,
  }) : super(key: key);

  final CameraDescription cameras;
  final String type;

  @override
  State<OpenCamera> createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initcontroler;
  String device = '';

  var isCameraReady = true;
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;

  double alignment_a = 0.7;
  double alignment_b = -0.9999999999999999;
  double alignment_c = -1.155;
  double alignment_d = 0.9999999999999998;
  double alignment_e = 3;
  double alignment_f = 20;
  late double sizewidth = 10;
  late double sizeheight = 28.6;
  bool isBasicsFlash = true;
  bool isdialog = false;
  bool isimage = false;
  bool isType = false;
  bool _isCameraPermissionGranted = false;
  late Timer timer;

  double alignmentValue_a = 4;
  double alignmentValue_b = 7.5;

  late double startDXPoint;
  late double startDYPoint;
  double alignmentwidth = 0.87;
  late double waistwidth = 120;
  late double inch = 48;

  // getPermissionStatus() async {
  //   await Permission.camera.request();
  //   var status = await Permission.camera.status;

  //   if (status.isGranted) {
  //     log('Camera Permission: GRANTED');
  //     setState(() {
  //       _isCameraPermissionGranted = true;
  //     });
  //     // Set and initialize the new camera
  //   } else {
  //     log('Camera Permission: DENIED');
  //   }
  // }

  @override
  void initState() {
    type();
    timer = Timer.periodic(
      const Duration(milliseconds: 300),
      (Timer t) => setState(
        () {
          if (isimage == true) {
            isimage = false;
          } else {
            isimage = true;
          }
        },
      ),
    );
    initCamera();
    WidgetsBinding.instance!.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  void type() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        isType = true;
      });
    } else if (widget.type == MyStyle().waistline) {
      setState(() {
        isType = false;
      });
    } else {
      print('เกิดผิดพลาด');
    }
  }

  // void _ondelay() {
  //   Future.delayed(const Duration(milliseconds: 50), () {
  //     setState(() {
  //       isimage = true;
  //     });
  //   });
  // }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null ? _initcontroler = _controller.initialize() : null;
    }
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }

  // Widget _cameraWidget(context) {
  //   var camera = _controller.value;
  //   final size = MediaQuery.of(context).size;
  //   var scale = size.aspectRatio * camera.aspectRatio;
  //   if (scale < 1) scale = 1 / scale;

  //   return Transform.scale(
  //     scale: scale,
  //     child: CameraPreview(_controller),
  //   );
  // }

  Widget _cameraWidget(context) {
    var camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Center(
      child: Container(
        width: screenwidth,
        height: screenheight * 0.967,
        child: Transform.scale(
          scale: scale,
          child: CameraPreview(_controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    device = ScreenSize().screenwidth(screenwidth);
    return Scaffold(
      body: newContent(),
    );
  }

  Widget newContent() {
    return SafeArea(
      child: FutureBuilder(
        future: _initcontroler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Stack(
                      alignment: device == 'MOBILE'
                          ? isType
                              ? const Alignment(0, -2)
                              : AlignmentDirectional.center
                          : isType
                              ? const Alignment(0, 0)
                              : AlignmentDirectional.center,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            _cameraWidget(context),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: icon(),
                              //iconCamerabutton(),
                            ),
                          ],
                        ),
                        isType ? line() : _isline(),
                        isType ? Container() : groupButton(),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                  ],
                ),
              ],
            );
          } else {
            return Container(
                color: Colors.black,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Loading.....',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
                // CircularProgressIndicator(),
                );
          }
        },
      ),
    );
  }

  Widget diviver() {
    return Container(
      color: Colors.white,
      child: const VerticalDivider(
        thickness: 5,
        width: 5,
        color: Colors.white,
      ),
    );
  }

  Widget _isline() {
    return device == 'MOBILE'
        ? Stack(
            alignment: Alignment(alignmentwidth, 0.35),
            children: [
              line(),
              GestureDetector(
                // onHorizontalDragStart: _onHorizontalDragStartHandler,
                // onHorizontalDragUpdate: _onDragUpdateHandler,
                onTap: () {
                  setState(() {
                    //  startDXPoint = startDXPoint;
                  });
                },
                child: Container(
                  // color: Colors.pink,
                  width: screenwidth * 0.3,
                  height: screenheight * 0.22,
                  // alignment: Alignment(startDXPoint, 0.35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _textcontainer(),
                      const SizedBox(
                        height: 8,
                      ),
                      Stack(
                        //  alignment: Alignment(alignmentwidth, 0.35),
                        children: [
                          isimage
                              ? Image.asset(
                                  'images/Line9.png',
                                  //height: 40,
                                )
                              : Image.asset(
                                  'images/Line7.png',
                                  // height: 40,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Stack(
            alignment: Alignment(alignmentwidth - 0.37, 0.25),
            //  alignment: Alignment(alignmentwidth, -10),
            children: [
              line(),
              GestureDetector(
                // onHorizontalDragStart: _onHorizontalDragStartHandler,
                // onHorizontalDragUpdate: _onDragUpdateHandler,
                onTap: () {
                  setState(() {
                    //  startDXPoint = startDXPoint;
                  });
                },
                child: Container(
                  width: screenwidth * 0.3,
                  height: screenheight * 0.22,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _textcontainer(),
                      const SizedBox(
                        height: 8,
                      ),
                      Stack(
                        //  alignment: Alignment(alignmentwidth, 0.35),
                        children: [
                          isimage
                              ? Image.asset(
                                  'images/Line9.png',
                                  //height: 40,
                                )
                              : Image.asset(
                                  'images/Line7.png',
                                  // height: 40,
                                ),
                          // _textcontainer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  // /// Track current point of a gesture
  void _onHorizontalDragStartHandler(DragStartDetails details) {
    setState(() {
      startDXPoint = details.localPosition.dx.floorToDouble() * 0.005;
      startDXPoint = startDXPoint;
      print('StartHandler Dx ==> ' + startDXPoint.toString());
      print('StartHandler Dy ==> ' + startDYPoint.toString());
    });
    if (startDXPoint <= 0.855) {
    } else {}
  }

  /// Track current point of a gesture
  void _onDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      startDXPoint = details.localPosition.dx.floorToDouble();
      double dx = startDXPoint * 0.005;

      // if (dx <= 0) {
      //   inch = waistwidth / 2.5;
      //   MyStyle().showBasicsFlash(
      //       context: context,
      //       text: 'ลดขนาดสูงสุดแล้ว',
      //       flashStyle: FlashBehavior.fixed,
      //       duration: const Duration(seconds: 2));
      // } else if (dx >= 0.87) {
      //   inch = waistwidth / 2.5;
      //   MyStyle().showBasicsFlash(
      //       context: context,
      //       text: 'เพิ่มขนาดสูงสุดแล้ว',
      //       flashStyle: FlashBehavior.fixed,
      //       duration: const Duration(seconds: 2));
      // } else {
      //   waistwidth = dx * 30;
      //   alignmentwidth = dx;
      // }
      waistwidth = dx * 30;
      inch = waistwidth / 2.5;
      alignmentwidth = dx;
      print('UpdateHandler Dx ==> ' + dx.toString());
      print('startDXPoint ==> ' + alignmentwidth.toString());
      print('waistwidth ==> ' + waistwidth.toString());
      print('=====================================');
    });
  }

  Widget line() {
    return device == 'MOBILE'
        ? isType
            ? Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenheight * 0.1,
                      ),
                      _textcontainer(),
                      Stack(
                        children: [
                          Stack(
                            alignment: Alignment(alignment_c, alignment_d),
                            children: [
                              Stack(
                                alignment: const Alignment(9, 22),
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: screenwidth * 0.18,
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Image.asset(
                                            'images/Line1.png',
                                            // width: screenwidth * 0.01,
                                            // height: screenwidth * 1.23,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: screenwidth * 0.13,
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Image.asset(
                                        'images/Line2.png',
                                        // width: screenwidth * 0.01,
                                        // height: screenwidth * 1.23,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment(alignment_a, alignment_b),
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: screenwidth * 0.13,
                                      ),
                                      isimage
                                          ? Image.asset(
                                              'images/Line3.png',
                                            )
                                          : Image.asset(
                                              'images/Line2.png',
                                            )
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: screenwidth * 0.01,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: screenwidth * 0.18,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: screenheight * 0.013,
                                        ),
                                        isimage
                                            ? Image.asset(
                                                'images/Line4.png',
                                                //  width: screenwidth * 0.01,
                                                //  height: screenheight * 0.612,
                                              )
                                            : Image.asset(
                                                'images/Line1.png',
                                                // width: screenwidth * 0.01,
                                                // height: screenheight * 0.612,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      groupButton(),
                    ],
                  ),
                ],
              )
            : Stack(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'images/Line7.png',
                                    // width: screenwidth * 0.01,
                                    // height: screenwidth * 1.23,
                                  ),
                                  Image.asset(
                                    'images/Line8.png',
                                    width: screenwidth * 0.6,
                                    // height: screenwidth * 1.23,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
        : isType
            ? Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      _textcontainer(),
                      Stack(
                        children: [
                          Stack(
                            alignment: Alignment(alignment_c, alignment_d),
                            children: [
                              Stack(
                                alignment: const Alignment(9, 22),
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: screenwidth * 0.325,
                                      ),
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Image.asset(
                                            'images/Line1.png',
                                            // width: screenwidth * 0.01,
                                            // height: screenwidth * 1.23,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: screenwidth * 0.3,
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Image.asset(
                                        'images/Line2.png',
                                        // width: screenwidth * 0.01,
                                        // height: screenwidth * 1.23,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Stack(
                            alignment:
                                Alignment((-1.73 + alignment_a), alignment_b),
                            children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: screenwidth * 0.3,
                                      ),
                                      isimage
                                          ? Image.asset(
                                              'images/Line3.png',
                                            )
                                          : Image.asset(
                                              'images/Line2.png',
                                            )
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: screenwidth * 0.69,
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      isimage
                                          ? Image.asset(
                                              'images/Line4.png',
                                              // width: screenwidth * 0.01,
                                              // height: screenwidth * 1.23,
                                            )
                                          : Image.asset(
                                              'images/Line1.png',
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      groupButton(),
                    ],
                  ),
                ],
              )
            : Stack(
                children: [
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: screenwidth * 0.01,
                                  ),
                                  Image.asset(
                                    'images/Line7.png',

                                    // width: screenwidth * 0.01,
                                    // height: screenwidth * 1.23,
                                  ),
                                  Image.asset(
                                    'images/Line8.png',
                                    //width: screenwidth * 0.6,
                                    // height: screenwidth * 1.23,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
  }

  Widget _textcontainer() {
    return device == 'MOBILE'
        ? Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(5)),
            width: screenwidth * 0.25,
            height: screenheight * 0.03,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isType
                      ? '${sizewidth.toStringAsFixed(0)} Cm'
                      : '${waistwidth.toStringAsFixed(0)} ซม.',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
                const Text(' | '),
                Text(
                  isType
                      ? '${sizeheight.toStringAsFixed(1)} Cm'
                      : '${inch.toStringAsFixed(1)} นิ้ว',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 14.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(5)),
            width: screenwidth * 0.2,
            height: screenheight * 0.03,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isType
                      ? '${sizewidth.toStringAsFixed(0)} Cm'
                      : '${waistwidth.toStringAsFixed(0)} ซม.',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 24.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
                const Text(' | '),
                Text(
                  isType
                      ? '${sizeheight.toStringAsFixed(1)} Cm'
                      : '${inch.toStringAsFixed(1)} นิ้ว',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 24.0,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
              ],
            ),
          );
  }

  void _showBasicsFlash({
    String? text,
    Duration? duration,
    flashStyle = FlashBehavior.floating,
  }) {
    showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.bottom,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Row(
              children: [
                const Icon(Icons.info_outline),
                MyStyle().mySizebox(),
                Text(text!),
              ],
            ),
          ),
        );
      },
    );
  }

  Row groupButton() {
    return isType
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (alignment_a >= 0.7 &&
                      alignment_b >= -0.9999999999999999) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: 'เพิ่มขนาดสูงสุดแล้ว',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print(
                        'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                  } else {
                    setState(
                      () {
                        alignmentValue_a += 0.002;
                        // alignmentValue_b -= 1;
                        alignment_a += 0.025;
                        alignment_b -= 0.03;
                        alignment_c -= 0.03;
                        alignment_d += 0.025;
                        sizewidth += 0.2;
                        sizeheight += 0.5;
                        print(
                            'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b\nalignment_c ===> $alignment_c\n alignment_d ===> $alignment_d');
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text(
                  'เพิ่มขนาด',
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (alignment_a <= 0.2749999999999996 &&
                      alignment_b <= -0.48999999999999944) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: 'ลดขนาดต่ำสุดแล้ว',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print(
                        'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                  } else {
                    setState(
                      () {
                        alignmentValue_a -= 0.002;
                        // alignmentValue_b += 1;
                        alignment_a -= 0.025;
                        alignment_b += 0.03;
                        alignment_c += 0.03;
                        alignment_d -= 0.025;

                        sizewidth -= 0.2;
                        sizeheight -= 0.5;
                        print(
                            'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b\nalignment_c ===> $alignment_c\n alignment_d ===> $alignment_d');
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.remove_circle_outline),
                label: const Text(
                  'ลดขนาด',
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: device == 'MOBILE'
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                padding: const EdgeInsets.only(top: 25.0, left: 30),
                onPressed: () {
                  if (device == 'MOBILE') {
                    if (alignmentwidth <= 0.00) {
                      MyStyle().showBasicsFlash(
                          context: context,
                          text: 'ลดขนาดต่ำสุดแล้ว',
                          flashStyle: FlashBehavior.fixed,
                          duration: const Duration(seconds: 2));
                      print('alignmentwidth ===> $alignmentwidth');
                    } else {
                      setState(
                        () {
                          alignmentwidth -= 0.01;
                          waistwidth -= 1;
                          inch = waistwidth / 2.5;
                          print('alignmentwidth ===> $alignmentwidth');
                        },
                      );
                    }
                  } else {
                    if (alignmentwidth <= 0.26999999999999946) {
                      MyStyle().showBasicsFlash(
                          context: context,
                          text: 'ลดขนาดต่ำสุดแล้ว',
                          flashStyle: FlashBehavior.fixed,
                          duration: const Duration(seconds: 2));
                      print('alignmentwidth ===> $alignmentwidth');
                    } else {
                      setState(
                        () {
                          alignmentwidth -= 0.01;
                          waistwidth -= 1;
                          inch = waistwidth / 2.5;
                          print('alignmentwidth ===> $alignmentwidth');
                        },
                      );
                    }
                  }
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(top: 25.0, right: 30),
                onPressed: () {
                  if (alignmentwidth >= 0.87) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: 'เพิ่มขนาดสูงสุดแล้ว',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print('alignmentwidth ===> $alignmentwidth');
                  } else {
                    setState(
                      () {
                        alignmentwidth += 0.01;
                        waistwidth += 1;
                        inch = waistwidth / 2.5;
                        print('alignmentwidth ===> $alignmentwidth');
                      },
                    );
                  }
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          );
  }

  Widget icon() => InkWell(
        child: Stack(
          alignment: Alignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Icon(
              Icons.circle,
              color: Colors.white38,
              size: 80,
            ),
            const Icon(
              Icons.circle,
              color: Colors.white,
              size: 65,
            ),
          ],
        ),
        onTap: () {
          captureImage(context);
        },
      );

  // Stack iconCamerabutton() => Stack(
  //       children: [
  //         FloatingActionButton(
  //           backgroundColor: Colors.white,
  //           child: const Icon(
  //             Icons.circle_outlined,
  //             color: Colors.black45,
  //             size: 55,
  //           ),
  //           onPressed: () {
  //             captureImage(context);
  //           },
  //         ),
  //       ],
  //     );

  captureImage(BuildContext context) {
    _controller.takePicture().then((file) {
      setState(() {
        imagefile = file;
      });
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            (MaterialPageRoute(
              builder: (context) => MeasurementResults(
                image: imagefile,
                width: isType ? sizewidth : waistwidth,
                height: isType ? sizeheight : 0,
                type: widget.type,
              ),
            )),
            (route) => true);
      }
    });
  }

  Future<void> initCamera() async {
    final firstCamera = widget.cameras;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initcontroler = _controller.initialize();
    if (!mounted) return;
    setState(() {
      isCameraReady = true;
    });
  }
}
