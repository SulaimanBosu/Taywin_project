// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_unnecessary_containers, camel_case_types, avoid_print, unused_element, sized_box_for_whitespace

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:taywin_project/utility/screen_size.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:taywin_project/widget/measurement_results.dart';

class OpenCamera2 extends StatefulWidget {
  const OpenCamera2({
    Key? key,
    required this.cameras,
    required this.type,
  }) : super(key: key);

  final CameraDescription cameras;
  final String type;

  @override
  State<OpenCamera2> createState() => _OpenCamera2State();
}

class _OpenCamera2State extends State<OpenCamera2> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initcontroler;
  String device = '';
  var isCameraReady = true;
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;
  double alignment = 0.0;
  double alignment_a = 0.22000000000000003;
  double alignment_b = -1.18999999999999878;
  double alignment_c = -0.20;
  double alignment_d = -1.0499999999999992;
  double alignment_e = -0.22000000000000003;
  double alignment_f = -1.0;
  double alignment_g = 0.19000000000000028;
  double alignment_h = 0.4;
  late double sizewidth = 10;
  late double sizeheight = 28.6;
  bool isColor = false;
  bool isType = false;
  bool _isCameraPermissionGranted = false;
  late Timer timer;
  double alignmentValue_b = 0;
  double alignmentwidth = 0.0;
  late double waistwidth = 20;
  late double inch = waistwidth / 2.5;
  double indent_a = 10;
  double endIndent_b = 10;
  double indent_c = 16;
  double endIndent_d = 15;
  Offset offset = const Offset(140, 0.0);
  bool flash_on = false;
  bool flash_off = false;

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
          if (isColor == true) {
            isColor = false;
          } else {
            isColor = true;
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
      body:
          //  _isGestureDetector(),
          newContent(),
    );
  }

  Widget newContent() {
    return SafeArea(
      child: FutureBuilder(
        future: _initcontroler,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Stack(
                      alignment: device == 'MOBILE'
                          ? isType
                              ? const Alignment(0, -0.5)
                              : AlignmentDirectional.center
                          : isType
                              ? const Alignment(0, 0)
                              : AlignmentDirectional.center,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            _cameraWidget(context),
                            Column(
                              children: [
                                isType ? Container() : _isSlider(context),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: icon(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        diviver(),
                        //  isType ? Container() : _isGestureDetector(),
                      ],
                    ),
                    action_button(context),
                    const VerticalDivider(
                      width: 20,
                      thickness: 1,
                      indent: 20,
                      endIndent: 0,
                      color: Colors.grey,
                    ),
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

  Padding action_button(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // _isFlashmode(),
          IconButton(
            onPressed: () {
              if (flash_on) {
                _controller.setFlashMode(FlashMode.off);

                setState(() {
                  flash_on = false;
                  flash_off = true;
                });
              } else if (flash_off) {
                _controller.setFlashMode(FlashMode.auto);
                setState(() {
                  flash_on = false;
                  flash_off = false;
                });
              } else {
                _controller.setFlashMode(FlashMode.torch);
                setState(() {
                  flash_on = true;
                  flash_off = false;
                });
              }
            },
            icon: flash_on
                ? const Icon(
                    Icons.flash_on_outlined,
                    color: Colors.yellow,
                  )
                : flash_off
                    ? const Icon(
                        Icons.flash_off_outlined,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.flash_auto_outlined,
                        color: Colors.yellow,
                      ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Stack _isSlider(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 30.0, bottom: 30, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                padding: const EdgeInsets.only(left: 30),
                onPressed: () {
                  if (alignmentwidth <= 0.0) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: 'ลดขนาดต่ำสุดแล้ว',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print('alignmentwidth ===> $alignmentwidth');
                  } else {
                    setState(
                      () {
                        alignmentwidth -= 0.05;
                        waistwidth -= 1;
                        inch = waistwidth / 2.5;
                        print('alignmentwidth ===> $alignmentwidth');
                      },
                    );
                  }
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                  size: 30,
                ),
              ),
              Slider(
                activeColor: const Color.fromARGB(255, 247, 166, 61),
                inactiveColor: const Color.fromARGB(255, 247, 243, 243),
                thumbColor: isColor ? Colors.green : Colors.red,
                // min: -3.5,
                // max: 1.0,
                min: -0.1,
                max: 5.1,
                value: alignmentwidth,
                onChanged: (value) {
                  if (value <= -0.1) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: 'ลดขนาดต่ำสุดแล้ว',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print('alignmentwidth ===> $alignmentwidth');
                  } else if (value >= 5.0) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: 'เพิ่มขนาดสูงสุดแล้ว',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print('alignmentwidth ===> $alignmentwidth');
                  } else {
                    setState(
                      () {
                        alignmentwidth = value;
                        waistwidth = (value * 100 / 5) + 20;
                        inch = waistwidth / 2.5;
                        print('alignmentwidth ===> $alignmentwidth');
                      },
                    );
                  }
                },
              ),
              IconButton(
                padding: const EdgeInsets.only(right: 30),
                onPressed: () {
                  if (alignmentwidth >= 5) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: 'เพิ่มขนาดสูงสุดแล้ว',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print('alignmentwidth ===> $alignmentwidth');
                  } else {
                    setState(
                      () {
                        alignmentwidth += 0.05;
                        waistwidth += 1;
                        inch = waistwidth / 2.5;
                        print('alignmentwidth ===> $alignmentwidth');
                      },
                    );
                  }
                },
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.green,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget diviver() {
    return isType
        ? Column(
            children: [
              Container(
                  alignment: Alignment(0, alignmentValue_b),
                  width: screenwidth * 0.3,
                  height: screenheight * 0.05,
                  child: _textcontainer()),
              SizedBox(
                height: screenheight * 0.01,
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: Alignment(alignment_a, alignment_b),
                        width: screenwidth * 0.14,
                        height: screenheight * 0.55,
                        // color: Colors.red,
                        child: VerticalDivider(
                          thickness: 5,
                          indent: indent_a,
                          endIndent: endIndent_b,
                          width: 5,
                          color: Colors.red,
                        ),
                      ),
                      //const SizedBox(width: 10,),
                      Container(
                        alignment: Alignment(alignment_c, alignment_d),
                        width: screenwidth * 0.14,
                        height: screenheight * 0.55,
                        // color: Colors.red,
                        child: VerticalDivider(
                          indent: indent_a,
                          endIndent: endIndent_b,
                          thickness: 5,
                          width: 5,
                          color: isColor
                              ? const Color.fromARGB(255, 247, 166, 61)
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment(alignment_e, alignment_f),
                                width: screenwidth * 0.56,
                                height: screenheight * 0.14,
                                // color: Colors.red,
                                child: Divider(
                                  indent: indent_c,
                                  endIndent: endIndent_d,
                                  thickness: 5,
                                  color: isColor ? Colors.red : Colors.green,
                                ),
                              ),
                              SizedBox(
                                height: screenheight * 0.285,
                              ),
                              Container(
                                alignment: Alignment(alignment_g, alignment_h),
                                width: screenwidth * 0.56,
                                height: screenheight * 0.157,
                                // color: Colors.red,
                                child: Divider(
                                  indent: indent_c,
                                  endIndent: endIndent_d,
                                  thickness: 5,
                                  height: 5,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              groupButton()
            ],
          )
        : Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                alignment: const Alignment(0, -5),
                width: screenwidth * 0.3,
                height: screenheight * 0.05,
                child: _textcontainer(),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Container(
                    width: screenwidth * 0.7,
                    height: screenheight * 0.14,
                    // color: Colors.red,
                    child: const Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 5,
                      color: Color.fromARGB(255, 247, 166, 61),
                    ),
                  ),
                  groupButton(),
                ],
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: const Alignment(-0.1, -1.0),
                        width: screenwidth * 0.14,
                        height: screenheight * 0.15,
                        child: VerticalDivider(
                          thickness: 5,
                          indent: indent_a,
                          endIndent: endIndent_b,
                          width: 5,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        alignment: Alignment(alignmentwidth - 4.7, 0),
                        width: screenwidth * 0.14,
                        height: screenheight * 0.15,
                        // color: Colors.red,
                        child: VerticalDivider(
                          indent: indent_a,
                          endIndent: endIndent_b,
                          thickness: 5,
                          width: 5,
                          color: isColor ? Colors.green : Colors.red,
                        ),
                      ),
                      //_isGestureDetector(),
                    ],
                  ),
                ],
              ),
            ],
          );
  }

  Widget _isGestureDetector() {
    double dx = 120;
    return Positioned(
      left: offset.dx,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (dx <= 110) {
            setState(() {
              offset = Offset(details.delta.dx, 0);
              //dx = dx + details.delta.dx;

              print(' DX ======> ${dx.toString()}');
            });
          } else {
            setState(() {
              offset = Offset(offset.dx + details.delta.dx, 0);
              dx = dx + details.delta.dx;

              print(' DX ======> ${dx.toString()}');
            });
          }

          // if (details.primaryDelta != 0.0) {
          //   setState(() {
          //     offset = Offset(offset.dx + details.delta.dx, 0);
          //     // min.add(details.delta.dx);
          //     print('details.primaryDelta ======> ${details.primaryDelta}');
          //   });
          // } else {
          //   setState(() {
          //     offset = Offset(offset.dx + details.delta.dx, 0);
          //     print('Offset DX ======> (offset.dx / 2.5 >= 120 ${offset.dx}');
          //   });
          // }
        },
        child: Container(
          width: screenwidth * 0.14,
          height: screenheight * 0.15,
          // color: Colors.red,
          child: VerticalDivider(
            indent: indent_a,
            endIndent: endIndent_b,
            thickness: 15,
            width: 5,
            color: isColor ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _textcontainer() {
    return device == 'MOBILE'
        ? Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(5)),
            width: screenwidth * 0.27,
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

  Row groupButton() {
    return isType
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (alignment_a >= 0.009999999999999953 &&
                      alignment_b >= -0.9799999999999986) {
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
                        alignmentValue_b -= 0.45;
                        alignment_a -= 0.07;
                        alignment_b += 0.07;
                        alignment_c += 0.07;
                        alignment_d -= 0.05;
                        alignment_e += 0.07;
                        alignment_f -= 0.07;
                        alignment_g -= 0.07;
                        alignment_h += 0.05;
                        sizewidth += 0.2;
                        sizeheight += 0.5;

                        indent_a -= 3;
                        endIndent_b -= 3;
                        indent_c -= 1.85;
                        endIndent_d -= 1.85;
                        print(
                            'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b\nalignment_c ===> $alignment_c\n alignment_d ===> $alignment_d\nalignment_e ===> $alignment_e\n alignment_f ===> $alignment_f\nalignment_g ===> $alignment_g\n alignment_h ===> $alignment_h');
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
                label: MyStyle().showtext_2('เพิ่มขนาด'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (alignment_a <= 1.3400000000000007 &&
                      alignment_b <= -2.3099999999999987) {
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
                        alignmentValue_b += 0.45;
                        alignment_a += 0.07;
                        alignment_b -= 0.07;
                        alignment_c -= 0.07;
                        alignment_d += 0.05;
                        alignment_e -= 0.07;
                        alignment_f += 0.07;
                        alignment_g += 0.07;
                        alignment_h -= 0.05;
                        indent_a += 3;
                        endIndent_b += 3;
                        indent_c += 1.85;
                        endIndent_d += 1.85;

                        sizewidth -= 0.2;
                        sizeheight -= 0.5;
                        print(
                            'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b\nalignment_c ===> $alignment_c\n alignment_d ===> $alignment_d\nalignment_e ===> $alignment_e\n alignment_f ===> $alignment_f\nalignment_g ===> $alignment_g\n alignment_h ===> $alignment_h');
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
                label: MyStyle().showtext_2('ลดขนาด'),
              ),
            ],
          )
        : Row();
    // Row(
    //     mainAxisAlignment: device == 'MOBILE'
    //         ? MainAxisAlignment.spaceBetween
    //         : MainAxisAlignment.spaceAround,
    //     children: [
    //       IconButton(
    //         padding: const EdgeInsets.only(left: 30),
    //         onPressed: () {
    //           if (alignmentwidth <= 0.0) {
    //             MyStyle().showBasicsFlash(
    //                 context: context,
    //                 text: 'ลดขนาดต่ำสุดแล้ว',
    //                 flashStyle: FlashBehavior.fixed,
    //                 duration: const Duration(seconds: 2));
    //             print('alignmentwidth ===> $alignmentwidth');
    //           } else {
    //             setState(
    //               () {
    //                 alignmentwidth -= 0.05;
    //                 waistwidth -= 1;
    //                 inch = waistwidth / 2.5;
    //                 print('alignmentwidth ===> $alignmentwidth');
    //               },
    //             );
    //           }
    //         },
    //         icon: const Icon(
    //           Icons.remove_circle_outline,
    //           color: Colors.white,
    //           size: 30,
    //         ),
    //       ),
    //       IconButton(
    //         padding: const EdgeInsets.only(right: 30),
    //         onPressed: () {
    //           if (alignmentwidth >= 5) {
    //             MyStyle().showBasicsFlash(
    //                 context: context,
    //                 text: 'เพิ่มขนาดสูงสุดแล้ว',
    //                 flashStyle: FlashBehavior.fixed,
    //                 duration: const Duration(seconds: 2));
    //             print('alignmentwidth ===> $alignmentwidth');
    //           } else {
    //             setState(
    //               () {
    //                 alignmentwidth += 0.05;
    //                 waistwidth += 1;
    //                 inch = waistwidth / 2.5;
    //                 print('alignmentwidth ===> $alignmentwidth');
    //               },
    //             );
    //           }
    //         },
    //         icon: const Icon(
    //           Icons.add_circle_outline,
    //           color: Colors.white,
    //           size: 30,
    //         ),
    //       ),
    //     ],
    //   );
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
        _controller.setFlashMode(FlashMode.auto);
        setState(() {
          flash_on = false;
          flash_off = false;
        });
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
