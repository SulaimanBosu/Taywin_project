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
  double alignment_e = 3;
  double alignment_f = 20;
  double sizewidth = 10;
  double sizeheight = 29.5;
  bool showFocusCircle = false;
  bool isBasicsFlash = true;
  bool isdialog = false;
  bool isimage = false;
  bool isType = false;
  late Timer timer;

  double alignmentValue_a = 4;
  double alignmentValue_b = 7.5;

  double startDXPoint = 0.895;
  double startDYPoint = 1;

  double waistwidth = 30;
   double inch = 12;

  @override
  void initState() {
    type();
    size();
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

  void size() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        sizewidth = 10;
        sizeheight = 29.5;
      });
    } else if (widget.type == MyStyle().waistline) {
      setState(() {
        // waistwidth = sizewidth * 3;
        // inch = waistwidth / 2.5;
      });
    } else {
      print('เกิดผิดพลาด');
    }
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
    return FutureBuilder(
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
                  //  alignment: AlignmentDirectional.center,
                  alignment: isType
                      ? const Alignment(0, -1.5)
                      : AlignmentDirectional.center,
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
                    isType
                        ? line()
                        : Stack(
                            alignment: Alignment(startDXPoint, 0.35),
                            
                            children: [
                              line(),
                              GestureDetector(
                                // onHorizontalDragStart:
                                //     _onHorizontalDragStartHandler,
                                onHorizontalDragUpdate: _onDragUpdateHandler,
                                child: Container(
                                  //color: Colors.pink,
                                  width: screenwidth * 0.3,
                                  height: screenheight * 0.22,
                                  // alignment: AlignmentDirectional.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _textcontainer(),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      line2(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
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

  // /// Track current point of a gesture
  // void _onHorizontalDragStartHandler(DragStartDetails details) {
  //   setState(() {
  //     // startDXPoint = details.localPosition.dx.floorToDouble();
  //     startDXPoint = details.localPosition.dx.floorToDouble() * 0.01;
  //     //startDXPoint = details.globalPosition.dx.floorToDouble();
  //     startDXPoint -= 0.1;
  //     print('Dx ==> ' + startDXPoint.toString());
  //     print('Dy ==> ' + startDYPoint.toString());
  //   });
  // }

  /// Track current point of a gesture
  void _onDragUpdateHandler(DragUpdateDetails details) {
    setState(() {
      startDXPoint = details.localPosition.dx.floorToDouble() * 0.005;
        waistwidth =  waistwidth - startDXPoint;
        inch = waistwidth / 2.5;
      //startDYPoint = details.globalPosition.dy.floorToDouble();
      print('Dx ==> ' + startDXPoint.toString());
      print('Dy ==> ' + startDYPoint.toString());
    });
  }

  Widget line() {
    return isType
        ? Stack(
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
                          _textcontainer(),
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
                        children: [
                          // _textcontainer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
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
              //  line2(),
            ],
          );
  }

  Widget line2() {
    return Stack(
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
    );
  }

  Widget _textcontainer() {
    return Container(
      // alignment: Alignment(alignmentValue_a, alignmentValue_b),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(5)),
      width: screenwidth * 0.25,
      height: screenheight * 0.03,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isType ? '${sizewidth.toStringAsFixed(0)} Cm' :
            '${waistwidth.toStringAsFixed(0)} ซม.',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
          const Text(' | '),
          Text(isType ? '${sizeheight.toStringAsFixed(1)} Cm' :
            '${inch.toStringAsFixed(1)} นิ้ว',
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 14.0,
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
                  sizewidth += 0.5;
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
                  sizewidth -= 0.5;
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
