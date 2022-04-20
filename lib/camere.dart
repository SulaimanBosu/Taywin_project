// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_unnecessary_containers, camel_case_types, avoid_print, unused_element, sized_box_for_whitespace

import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taywin_project/measurement_results.dart';
import 'package:taywin_project/utility/my_style.dart';

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

  var isCameraReady = true;
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;
  double alignment_a = 0.7;
  double alignment_b = -0.9999999999999999;
  double alignment_c = -1.155;
  double alignment_d = 0.9999999999999998;
  double alignment_e = -1.3;
  double alignment_f = 1.3;
  int sizewidth = 10;
  int sizeheight = 25;
  late int sizeTH = 39;
  late double sizeUS = 8;
  late double sizeUK = 6;
  bool isBasicsFlash = true;
  bool isdialog = false;
  bool isimage = false;
  bool isType = false;
  late Timer timer;

  double alignmentValue_a = 4;
  double alignmentValue_b = 7.5;

  @override
  void initState() {
    cameraType();
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
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

  void cameraType() {
    if (widget.type == 'footmeasure') {
      setState(() {
        isType = true;
      });
    } else {}
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

  Widget _cameraWidget(context) {
    var camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Transform.scale(
      scale: scale,
      child: CameraPreview(_controller),
    );
  }

  Widget _camera(context) {
    var camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Center(
      child: Container(
        width: screenwidth * 0.5,
        height: screenheight * 0.5,
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
    return Scaffold(
      body: newContent(),
    );
  }

  FutureBuilder<void> newContent() {
    return isType
        ? FutureBuilder(
            future: _initcontroler,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  // color: Colors.black,
                  width: screenwidth,
                  height: screenheight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              _cameraWidget(context),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: iconCamerabutton(),
                              ),
                            ],
                          ),
                          line(),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        : FutureBuilder(
            future: _initcontroler,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  // color: Colors.black,
                  width: screenwidth,
                  height: screenheight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              _cameraWidget(context),
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: iconCamerabutton(),
                              ),
                            ],
                          ),
                          //  line(),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
  }

  Widget line() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Stack(
                  alignment: Alignment(alignment_c, alignment_d),
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Stack(
                      alignment: const Alignment(9, 5),
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 85,
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 85,
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
                        const SizedBox(
                          width: 65,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                                //height: 8,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              right: screenwidth * 0.0005,
                              top: screenwidth / alignmentValue_b),
                          // alignment: Alignment(alignmentValue_a, alignmentValue_b),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadiusDirectional.circular(5)),
                          width: screenwidth * 0.18,
                          height: screenheight * 0.03,

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$sizewidth CM',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 14.0,
                                  fontFamily: 'FC-Minimal-Regular',
                                ),
                              ),
                              const Text(' | '),
                              Text(
                                '$sizeheight CM',
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14.0,
                                  fontFamily: 'FC-Minimal-Regular',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 63,
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
                        const SizedBox(
                          width: 85,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            isimage
                                ? Image.asset(
                                    'images/Line4.png',
                                    // width: screenwidth * 0.01,
                                    // height: screenwidth * 1.23,
                                  )
                                : Image.asset(
                                    'images/Line1.png',
                                  )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            groupButton(),
          ],
        ),
      ],
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            if (alignment_a >= 0.7 && alignment_b >= -0.9999999999999999) {
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
                  alignment_a += 0.05;
                  alignment_b -= 0.05;
                  alignment_c -= 0.05;
                  alignment_d += 0.05;
                  alignment_e -= 0.05;
                  alignment_f += 0.05;
                  sizewidth += 1;
                  sizeheight += 1;
                  sizeTH += 1;
                  sizeUS += 0.5;
                  sizeUK += 0.5;
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
            //shadowColor: const Color.fromRGBO(30, 29, 89, 1),
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
            if (alignment_a <= 0.1999999999999999 &&
                alignment_b <= -0.4999999999999995) {
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
                  alignment_a -= 0.05;
                  alignment_b += 0.05;
                  alignment_c += 0.05;
                  alignment_d -= 0.05;
                  alignment_e += 0.05;
                  alignment_f -= 0.05;
                  sizewidth -= 1;
                  sizeheight -= 1;
                  sizeTH -= 1;
                  sizeUS -= 0.5;
                  sizeUK -= 0.5;
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
            //shadowColor: const Color.fromRGBO(30, 29, 89, 1),
          ),
          icon: const Icon(Icons.remove_circle_outline),
          label: const Text(
            'ลดขนาด',
          ),
        ),
      ],
    );
  }

  Stack iconCamerabutton() => Stack(
        alignment: Alignment(alignment_a, alignment_b),
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.circle_outlined,
              color: Colors.black45,
              size: 55,
            ),
            onPressed: () {
              captureImage(context);
             
            },
          ),
        ],
      );

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
                width: sizewidth,
                height: sizeheight,
                sizeTH: sizeTH,
                sizeUS: sizeUS,
                sizeUK: sizeUK,
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
