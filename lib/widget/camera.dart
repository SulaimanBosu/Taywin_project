// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_unnecessary_containers, camel_case_types, avoid_print, unused_element, sized_box_for_whitespace, prefer_typing_uninitialized_variables, import_of_legacy_library_into_null_safe

import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taywin_project/main.dart';
import 'package:taywin_project/utility/screen_size.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:taywin_project/widget/measurement_results.dart';

class OpenCamera extends StatefulWidget {
  const OpenCamera({
    Key? key,
    required this.screenwidth,
    required this.screenheight,
    required this.type,
  }) : super(key: key);

  final String type;
  final double screenwidth;
  final double screenheight;

  @override
  State<OpenCamera> createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initcontroler;
  bool _isRearCameraSelected = true;
  String device = '';
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;
  double alignment_a = -0.3;
  double alignment_b = -1.19;
  double alignment_c = 0.1;
  double alignment_d = -1.06;
  double alignment_e = -0.22000000000000003;
  double alignment_f = -0.92;
  double alignment_g = 0.19000000000000028;
  double alignment_h = 1.80;
  double sizewidth = 10;
  double sizeheight = 28.6;
  bool isColor = false;
  bool isType = false;
  late Timer timer;
  double alignmentValue_b = 0;
  late double waistwidth;
  late double inch = waistwidth / 2.5;
  double indent_a = 0;
  double endIndent_b = 0;
  double indent_c = 8;
  double endIndent_d = 8;
  Offset offset = const Offset(480, 0.0);
  Offset _Greenline = const Offset(77.0, 117.0);
  Offset _OrangeLine = const Offset(270, 141.5);
  bool flash_on = false;
  bool flash_off = false;
  late double size;
  late Size sizeScreen;
  late double scale;
  bool isMan = false;
  final controller = JustTheController();
  final selectcameraTooltip = JustTheController();
  bool _istooltip = true;
  bool _isCameraPermissionGranted = false;

  late MediaQueryData queryData;

  double endIndent = 0;

  getPermissionStatus() async {
    var status = await Permission.camera.status;

    var status_storage = await Permission.storage.status;

    var microphone = await Permission.microphone.status;

    if (status.isGranted && status_storage.isGranted && microphone.isGranted) {
      debugPrint('Camera ==============>>> Permission: GRANTED');
      setState(() {
        _isCameraPermissionGranted = true;
        _state();
      });
      // Set and initialize the new camera
    } else {
      setState(() async {
        debugPrint('Camera ==============>> Permission: DENIED');
        await Permission.camera.request();
        await Permission.storage.request();
        await Permission.microphone.request();
        await Permission.mediaLibrary.request();
        await Permission.photosAddOnly.request();
        _isCameraPermissionGranted = true;
        Future.delayed(const Duration(milliseconds: 1000), () {
          _state();
        });
      });
      // debugPrint('Camera ==============>> Permission: DENIED');
    }
  }

  void _state() {
    setState(() {
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
      WidgetsBinding.instance!.addObserver(this);
      isType
          ? SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
            ])
          : SystemChrome.setPreferredOrientations([
              DeviceOrientation.landscapeLeft,
            ]);
    });
  }

  @override
  void initState() {
    getPermissionStatus();
    debugPrint('screenheight =========${widget.screenheight}');
    super.initState();
  }

  void delaydialog() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _showAlertDialog(true, const AssetImage('images/man.png'), context,
            '????????????????????????', '???????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????');
      });
    });
  }

  void type() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        initCamera(cameras[0]);
        isType = true;
      });
    } else if (widget.type == MyStyle().waistline) {
      setState(() {
        initCamera(cameras[1]);
        delaydialog();
        isType = false;

        if (isMan) {
          size = (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.08) * 2;
        } else {
          size = (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.79) * 2;
        }
        waistwidth = size + 26;
        // waistwidth = size + 33;
        inch = (waistwidth / 2.54);
      });
    } else {
      print('?????????????????????????????????');
    }
  }

  void _ondelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        Navigator.pop(context);
      });
    });
  }

  @override
  void dispose() {
    //     SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    WidgetsBinding.instance?.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null ? _initcontroler = _controller.initialize() : null;
    }
    if (!mounted) return;
  }

  Widget _cameraWidget(context) {
    var camera = _controller.value;
    sizeScreen = MediaQuery.of(context).size;
    scale = sizeScreen.aspectRatio * camera.aspectRatio;

    if (scale < 1) {
      scale = 1 / scale;
      // print('scale ======= $scale');
    } else if (scale > 1) {
      scale = 1;
      // print('scale ======= $scale');
    }
    return Container(
      width: screenwidth,
      height: screenheight,
      color: Colors.black,
      child: Transform.scale(
        scale: scale,
        child: CameraPreview(_controller),
      ),
    );
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    final firstCamera = cameraDescription;
    _controller = CameraController(firstCamera, ResolutionPreset.high);
    _initcontroler = _controller.initialize();
    if (!mounted) return;
  }

  // Widget _cameraWidget(context) {
  //   var camera = _controller.value;
  //   final size = MediaQuery.of(context).size;
  //   var scale = size.aspectRatio * camera.aspectRatio;
  //   if (scale < 1) scale = 1 / scale;
  //   return Center(
  //     child: Container(
  //       width: screenwidth,
  //       height: screenheight * 0.967,
  //       child: Transform.scale(
  //         scale: scale,
  //         child: CameraPreview(_controller),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    device = ScreenSize().screenwidth(screenwidth);
    return Scaffold(
      body: !_isCameraPermissionGranted
          ? Container(
              color: Colors.black,
            )
          : newContent(),
    );
  }

  Widget newContent() {
    return FutureBuilder(
      future: _initcontroler,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Stack(
                    //  alignment: device == 'MOBILE'
                    //      ?
                    alignment: isType
                        ? const Alignment(0, -3.0)
                        : AlignmentDirectional.center,
                    // : isType
                    //     ? const Alignment(0, 0)
                    //     : AlignmentDirectional.center,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          _cameraWidget(context),
                          Column(
                            children: [
                              isType
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        isType
                                            ? Container()
                                            : iconCameraSelected(),

                                        Container(
                                          // padding:
                                          //     const EdgeInsets.only(bottom: 10),
                                          child: icon(),
                                        ),
                                        isType ? Container() : typeButton(),
                                        // Container(
                                        //   margin:
                                        //       const EdgeInsets.only(right: 10),
                                        // ),
                                      ],
                                    ),
                            ],
                          ),
                        ],
                      ),
                      // divider2(),
                      // isType ? _isOrangeLine() : Container(),
                      // isType ? _isGreenLine() : Container(),
                      divider(),
                      isType ? Container() : _isGestureDetector(),
                    ],
                  ),
                  action_button(context),
                  //_isSlider(context)
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
                    const CupertinoActivityIndicator(
                      radius: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Loading...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
              // CircularProgressIndicator(),
              );
        }
      },
    );
  }

  Widget action_button(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: screenheight * 0.05),
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

  Widget _isSlider(BuildContext context) {
    return RotatedBox(
      quarterTurns: 5,
      child: Container(
        height: 30,
        child: Slider(
          activeColor: const Color.fromARGB(255, 247, 166, 61),
          inactiveColor: const Color.fromARGB(255, 247, 243, 243),
          thumbColor: isColor ? Colors.green : Colors.red,
          // min: -3.5,
          // max: 1.0,
          min: 20,
          max: 1314,
          value: offset.dx,
          onChanged: (value) {
            debugPrint('Value ========= ${value.toString()}');
            // if (value <= 124) {
            //   MyStyle().showBasicsFlash(
            //       context: context,
            //       text: '????????????????????????????????????????????????',
            //       flashStyle: FlashBehavior.fixed,
            //       duration: const Duration(seconds: 2));
            // } else if (value >= 310) {
            //   MyStyle().showBasicsFlash(
            //       context: context,
            //       text: '?????????????????????????????????????????????????????????',
            //       flashStyle: FlashBehavior.fixed,
            //       duration: const Duration(seconds: 2));
            // } else {
            //   setState(
            //     () {
            //       offset = Offset(value, 0);
            //       waistwidth = offset.dx * 100 / 300;
            //       inch = waistwidth / 2.5;

            //       // alignmentwidth = value;
            //       // waistwidth = (value * 100 / 5) + 20;
            //       // inch = waistwidth / 2.5;
            //       // print('alignmentwidth ===> $alignmentwidth');
            //     },
            //   );
            // }
          },
        ),
      ),
    );
  }

  Widget divider2() {
    return isType
        ? Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenheight * 0.1,
              ),
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
                        alignment: Alignment(-3.5, alignment_b),
                        width: screenwidth * 0.14,
                        height: screenheight * 0.63,
                        // color: Colors.red,
                        child: VerticalDivider(
                          thickness: 10,
                          indent: indent_a,
                          endIndent: endIndent_b,
                          width: 5,
                          color: Colors.red,
                        ),
                      ),
                      //const SizedBox(width: 10,),
                      //_isorangeLine(),
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
                              //   _isGreenLine(),
                              SizedBox(
                                height: screenheight * 0.285,
                              ),
                              Container(
                                alignment: Alignment(alignment_g, 2.3),
                                width: screenwidth * 0.62,
                                height: screenheight * 0.157,
                                // color: Colors.red,
                                child: Divider(
                                  indent: indent_c,
                                  endIndent: endIndent_d,
                                  thickness: 10,
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
              Column(
                children: [
                  // groupButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  icon(),
                ],
              )
            ],
          )
        : Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                alignment: const Alignment(0, -5),
                width: screenwidth * 0.3,
                height: screenheight * 0.085,
                child: _textcontainer(),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Container(
                    width: screenwidth * 99 / 100,
                    height: screenheight * 0.24,
                    // color: Colors.red,
                    child: Divider(
                      indent: screenwidth * 0.5 / 100,
                      endIndent: screenwidth * 0.01,
                      thickness: 5,
                      color: const Color.fromARGB(255, 247, 166, 61),
                    ),
                  ),
                  //  groupButton(),
                ],
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: const Alignment(-4.1, -1.0),
                        width: screenwidth * 0.14,
                        height: screenheight * 0.25,
                        child: VerticalDivider(
                          thickness: 10,
                          indent: indent_a,
                          endIndent: endIndent_b,
                          width: 5,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      // Container(
                      //   alignment: Alignment(alignmentwidth - 4.7, 0),
                      //   width: screenwidth * 0.14,
                      //   height: screenheight * 0.15,
                      //   // color: Colors.red,
                      //   child: VerticalDivider(
                      //     indent: indent_a,
                      //     endIndent: endIndent_b,
                      //     thickness: 5,
                      //     width: 5,
                      //     color: isColor ? Colors.green : Colors.red,
                      //   ),
                      // ),
                      //_isGestureDetector(),
                    ],
                  ),
                ],
              ),
            ],
          );
  }

  Widget _isGreenLine() {
    return Positioned(
      top: _Greenline.dy,
      left: _Greenline.dx,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _Greenline =
                Offset(_Greenline.dx, _Greenline.dy + details.delta.dy);
            // _OrangeLine =
            //     Offset(_OrangeLine.dx - details.delta.dy, _OrangeLine.dy);
            // sizewidth = (_OrangeLine.dx / 100) * 5 - 3.5;

            // if (_Greenline.dy <= 117 || _OrangeLine.dx >= 270) {
            //   _Greenline = Offset(_Greenline.dx, 117);
            //   _OrangeLine = Offset(270, _OrangeLine.dy);

            //   MyStyle().showBasicsFlash(
            //       context: context,
            //       text: '??????????????????????????????????????????????????????????????????',
            //       flashStyle: FlashBehavior.fixed,
            //       duration: const Duration(seconds: 2));
            // } else if (_Greenline.dy >= 200 || _OrangeLine.dx <= 190) {
            //   _Greenline = Offset(_Greenline.dx, 200);
            //   _OrangeLine = Offset(190, _OrangeLine.dy);
            //   MyStyle().showBasicsFlash(
            //       context: context,
            //       text: '?????????????????????????????????????????????????????????',
            //       flashStyle: FlashBehavior.fixed,
            //       duration: const Duration(seconds: 2));
            // } else {}

            if (_Greenline.dy <= 117) {
              _Greenline = Offset(_Greenline.dx, 117);
              MyStyle().showBasicsFlash(
                  context: context,
                  text: '??????????????????????????????????????????????????????????????????',
                  flashStyle: FlashBehavior.fixed,
                  duration: const Duration(seconds: 2));
            } else if (_Greenline.dy >= 200) {
              _Greenline = Offset(_Greenline.dx, 200);
              MyStyle().showBasicsFlash(
                  context: context,
                  text: '?????????????????????????????????????????????????????????',
                  flashStyle: FlashBehavior.fixed,
                  duration: const Duration(seconds: 2));
            } else {}
            sizeheight = 40.3 - (_Greenline.dy / 10);

            print('_offset.dy ======> ${_Greenline.dy.toString()}');
          });
        },
        child: Container(
          width: screenwidth * 0.62,
          height: screenheight * 0.14,
          // color: Colors.red,
          child: Divider(
            indent: indent_c,
            endIndent: endIndent_d,
            thickness: 10,
            color: isColor ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }

  Widget _isOrangeLine() {
    return Positioned(
      left: _OrangeLine.dx,
      top: _OrangeLine.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _OrangeLine =
                Offset(_OrangeLine.dx + details.delta.dx, _OrangeLine.dy);
            // _Greenline =
            //     Offset(_Greenline.dx, _Greenline.dy - details.delta.dx);
            // sizeheight = 40.3 - (_Greenline.dy / 10);

            // if (_OrangeLine.dx >= 270 || _Greenline.dy <= 117) {
            //   _OrangeLine = Offset(270, _OrangeLine.dy);
            //   _Greenline = Offset(_Greenline.dx, 117);
            // } else if (_OrangeLine.dx <= 190 || _Greenline.dy >= 200) {
            //   _OrangeLine = Offset(190, _OrangeLine.dy);
            //   _Greenline = Offset(_Greenline.dx, 200);
            // } else {}

            if (_OrangeLine.dx >= 270) {
              _OrangeLine = Offset(270, _OrangeLine.dy);
            } else if (_OrangeLine.dx <= 190) {
              _OrangeLine = Offset(190, _OrangeLine.dy);
            } else {}
            sizewidth = (_OrangeLine.dx / 100) * 5 - 3.5;
            print('_OrangeLine.dx ======> ${_OrangeLine.dx.toString()}');
          });
        },
        child: Container(
          width: screenwidth * 0.14,
          height: screenheight * 0.63,
          // color: Colors.red,
          child: VerticalDivider(
            indent: indent_a,
            endIndent: endIndent_b,
            thickness: 10,
            width: 5,
            color:
                isColor ? const Color.fromARGB(255, 247, 166, 61) : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return isType
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: screenheight * 0.1,
              ),
              Container(
                alignment: const Alignment(0, -1),
                width: screenwidth * 0.3,
                height: screenheight * 0.05,
                child: _textcontainer(),
              ),
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
                        height: screenheight * 0.65,
                        // color: Colors.red,
                        child: VerticalDivider(
                          thickness: 10,
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
                        height: screenheight * 0.65,
                        // color: Colors.red,
                        child: VerticalDivider(
                          indent: indent_a,
                          endIndent: endIndent_b,
                          thickness: 10,
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
                                width: screenwidth * 0.62,
                                height: screenheight * 0.14,
                                // color: Colors.red,
                                child: Divider(
                                  indent: indent_c,
                                  endIndent: endIndent_d,
                                  thickness: 10,
                                  color: isColor ? Colors.green : Colors.red,
                                ),
                              ),
                              SizedBox(
                                height: screenheight * 0.285,
                              ),
                              Container(
                                alignment: Alignment(alignment_g, alignment_h),
                                width: screenwidth * 0.62,
                                height: screenheight * 0.157,
                                // color: Colors.red,
                                child: Divider(
                                  indent: indent_c,
                                  endIndent: endIndent_d,
                                  thickness: 10,
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
              Column(
                children: [
                  groupButton(),
                  icon(),
                ],
              )
            ],
          )
        : Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                alignment: const Alignment(0, -5),
                width: screenwidth * 0.3,
                height: screenheight * 0.085,
                child: _textcontainer(),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(
                alignment: const Alignment(0, 0),
                children: [
                  Container(
                    padding: EdgeInsets.only(left: screenwidth * 11 / 100),
                    width: screenwidth * 95 / 100,
                    //width: screenwidth * 99 / 100,
                    height: screenheight * 0.24,
                    // color: Colors.red,
                    child: Divider(
                      indent: screenwidth * 0.5 / 100,
                      endIndent: endIndent,
                      thickness: 5,
                      color: const Color.fromARGB(255, 247, 166, 61),
                    ),
                  ),
                  //  groupButton(),
                ],
              ),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: const Alignment(-2.1, -1.0),
                        //  alignment: const Alignment(-4.1, -1.0),
                        width: screenwidth * 0.14,
                        height: screenheight * 0.25,
                        child: VerticalDivider(
                          thickness: 10,
                          indent: indent_a,
                          endIndent: endIndent_b,
                          width: 5,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      // Container(
                      //   alignment: Alignment(alignmentwidth - 4.7, 0),
                      //   width: screenwidth * 0.14,
                      //   height: screenheight * 0.15,
                      //   // color: Colors.red,
                      //   child: VerticalDivider(
                      //     indent: indent_a,
                      //     endIndent: endIndent_b,
                      //     thickness: 5,
                      //     width: 5,
                      //     color: isColor ? Colors.green : Colors.red,
                      //   ),
                      // ),
                      //_isGestureDetector(),
                    ],
                  ),
                ],
              ),
            ],
          );
  }

  Widget typeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isMan = !isMan;
              isMan
                  ? _showtDialog(
                      const AssetImage('images/man.png'),
                      context,
                      '??????????????????????????????????????????',
                      '?????????????????????????????????????????????????????????????????????????????????????????????\n 40 ??????.???????????? 15 ????????????????????????????????????')
                  : _showtDialog(
                      const AssetImage('images/woman.png'),
                      context,
                      '???????????????????????????????????????',
                      '?????????????????????????????????????????????????????????????????????????????????????????????\n 30 ??????.???????????? 12 ????????????????????????????????????');
              // if (isMan) {
              //   size =
              //       (((offset.dx - 73.2) * 100 / widget.screenheight) / 1.65) *
              //           2;
              // } else {
              //   size =
              //       (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.05) *
              //           2;
              // }
              // waistwidth = size + 15;
              // inch = waistwidth / 2.54;
              if (isMan) {
                size =
                    (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.08) *
                        2;
              } else {
                size =
                    (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.79) *
                        2;
              }
              waistwidth = size + 26;
              // waistwidth = size + 33;
              inch = (waistwidth / 2.54);
            });
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                JustTheTooltip(
                  controller: controller,
                  onShow: controller.showTooltip,
                  onDismiss: controller.hideTooltip,
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      isMan
                          ? '??????????????????????????????????????????????????????????????????????????????????????????????????????????????????'
                          : '?????????????????????????????????????????????????????????????????????????????????????????????????????????????????????',
                      style: const TextStyle(
                        fontFamily: 'FC-Minimal-Regular',
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageIcon(
                          AssetImage(
                              isMan ? 'images/man.png' : 'images/woman.png'),
                          size: 20,
                          color: Colors.white,
                        ),
                        const ImageIcon(
                          AssetImage('images/icons-circle.png'),
                          size: 40,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  isMan ? '??????????????????????????????????????????' : '???????????????????????????????????????',
                  style: const TextStyle(
                    fontFamily: 'FC-Minimal-Regular',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _isGestureDetector2() {
    return Positioned(
      left: offset.dx,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset = Offset(offset.dx + details.delta.dx, 0);
            if (offset.dx >= (widget.screenheight * 91 / 100)) {
              offset = Offset(widget.screenheight * 91 / 100, 0);
              MyStyle().showBasicsFlash(
                  context: context,
                  text: '?????????????????????????????????????????????????????????',
                  flashStyle: FlashBehavior.fixed,
                  duration: const Duration(seconds: 2));
            } else if (offset.dx <= widget.screenheight * 30 / 100) {
              offset = Offset(widget.screenheight * 30 / 100, 0);
              MyStyle().showBasicsFlash(
                  context: context,
                  text: '????????????????????????????????????????????????',
                  flashStyle: FlashBehavior.fixed,
                  duration: const Duration(seconds: 2));
            } else {}
            if (isMan) {
              size =
                  (((offset.dx - 73.2) * 100 / widget.screenheight) / 1.65) * 2;
              // size = (((offset.dx + 30) * 100 / widget.screenheight) / 1.7) * 2;
            } else {
              size =
                  (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.05) * 2;
              // size = (((offset.dx + 30) * 100 / widget.screenheight) / 2.1) * 2;
            }
            // size = (((offset.dx * 100) / screenwidth - 12));
            // size = (((offset.dx * 100) / screenwidth + 12));
            waistwidth = size + 15;
            inch = (waistwidth / 2.54);
            print('endIndent ======> ${endIndent.toString()}');
            print('offset.dx ======> ${offset.dx.toString()}');
            print('screenwidth ======> ${screenwidth.toString()}');
          });
        },
        child: Container(
          width: screenwidth * 0.14,
          height: screenheight * 0.25,
          child: VerticalDivider(
            indent: 5,
            endIndent: 5,
            thickness: 12,
            width: 5,
            color: isColor ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _isGestureDetector() {
    return Positioned(
      left: offset.dx,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset = Offset(offset.dx + details.delta.dx, 0);
            if (offset.dx >= (widget.screenheight * 91 / 100)) {
              offset = Offset(widget.screenheight * 91 / 100, 0);
              MyStyle().showBasicsFlash(
                context: context,
                text: '?????????????????????????????????????????????????????????',
                flashStyle: FlashBehavior.fixed,
                duration: const Duration(seconds: 2),
              );
            } else if (offset.dx <= widget.screenheight * 30 / 100) {
              offset = Offset(widget.screenheight * 30 / 100, 0);
              MyStyle().showBasicsFlash(
                context: context,
                text: '????????????????????????????????????????????????',
                flashStyle: FlashBehavior.fixed,
                duration: const Duration(seconds: 2),
              );
            }
            //else {}
            if (isMan) {
              size =
                  (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.08) * 2;
            } else {
              size =
                  (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.79) * 2;
            }
            waistwidth = size + 26;
            // waistwidth = size + 33;
            inch = (waistwidth / 2.54);
            print('endIndent ======> ${endIndent.toString()}');
            print('offset.dx ======> ${offset.dx.toString()}');
            print('screenwidth ======> ${screenwidth.toString()}');
          });
        },
        child: Container(
          width: screenwidth * 0.14,
          height: screenheight * 0.25,
          child: VerticalDivider(
            indent: 5,
            endIndent: 5,
            thickness: 12,
            width: 5,
            color: isColor ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _textcontainer() {
    return
        // device == 'MOBILE'
        //     ?
        Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(5)),
      width: isType ? screenwidth * 0.3 : screenwidth * 0.16,
      height: isType ? screenheight * 0.03 : screenheight * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isType
                ? '${sizewidth.toStringAsFixed(1)} ??????.'
                : '${waistwidth.toStringAsFixed(0)} ??????.',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
          const Text(' | '),
          Text(
            isType
                ? '${sizeheight.toStringAsFixed(1)} ??????.'
                : '${inch.toStringAsFixed(1)} ????????????',
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 14.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
        ],
      ),
    );
    // : Container(
    //     decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadiusDirectional.circular(5)),
    //     width: isType ? screenwidth * 0.3 : screenwidth * 0.2,
    //     height: isType ? screenheight * 0.03 : screenheight * 0.05,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           isType
    //               ? '${sizewidth.toStringAsFixed(0)} ??????.'
    //               : '${waistwidth.toStringAsFixed(0)} ??????.',
    //           style: const TextStyle(
    //             color: Colors.green,
    //             fontSize: 14.0,
    //             fontFamily: 'FC-Minimal-Regular',
    //           ),
    //         ),
    //         const Text(' | '),
    //         Text(
    //           isType
    //               ? '${sizeheight.toStringAsFixed(1)} ??????.'
    //               : '${inch.toStringAsFixed(1)} ????????????',
    //           style: const TextStyle(
    //             color: Colors.orange,
    //             fontSize: 14.0,
    //             fontFamily: 'FC-Minimal-Regular',
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
  }

  Widget groupButton() {
    return isType
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (sizewidth >= 10.0 || sizeheight >= 28.6) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: '?????????????????????????????????????????????????????????',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print(
                        'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                  } else {
                    setState(
                      () {
                        alignmentValue_b -= 0.4;
                        // alignment_a -= 0.075;
                        // alignment_b += 0.075;
                        alignment_c += 0.15;
                        alignment_d -= 0.060;
                        alignment_e += 0.15;
                        alignment_f -= 0.182;
                        // alignment_g -= 0.075;
                        // alignment_h += 0.080;
                        sizewidth += 0.2;
                        sizeheight += 0.5;

                        indent_a -= 7.7;
                        // endIndent_b -= 4.0;
                        // indent_c -= 1.85;
                        endIndent_d -= 3.70;
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
                label: MyStyle().showtext_2('???????????????????????????'),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  if (sizewidth <= 6.8 || sizeheight <= 20.6) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: '????????????????????????????????????????????????',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                    print(
                        'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                  } else {
                    setState(
                      () {
                        alignmentValue_b += 0.4;
                        // alignment_a += 0.075;
                        // alignment_b -= 0.075;
                        alignment_c -= 0.15;
                        alignment_d += 0.060;
                        alignment_e -= 0.15;
                        alignment_f += 0.182;
                        // alignment_g += 0.075;
                        // alignment_h -= 0.080;

                        indent_a += 7.7;
                        // endIndent_b += 4.0;
                        // indent_c += 1.85;
                        endIndent_d += 3.70;

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
                label: MyStyle().showtext_2('??????????????????'),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: device == 'MOBILE'
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                padding: const EdgeInsets.only(left: 25),
                onPressed: () {
                  if (offset.dx <= 47.0) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: '????????????????????????????????????????????????',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                  } else {
                    setState(
                      () {
                        offset = Offset(offset.dx - 3, 0);
                        size = (((offset.dx * 100) / 545) - 8.5);
                        waistwidth = size;
                        inch = (waistwidth / 2.54);
                        //  alignmentwidth -= 0.05;
                        // waistwidth -= 1;
                        // inch = waistwidth / 2.5;
                      },
                    );
                  }
                },
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(right: 30),
                onPressed: () {
                  if (offset.dx >= 592) {
                    MyStyle().showBasicsFlash(
                        context: context,
                        text: '?????????????????????????????????????????????????????????',
                        flashStyle: FlashBehavior.fixed,
                        duration: const Duration(seconds: 2));
                  } else {
                    setState(
                      () {
                        offset = Offset(offset.dx + 3, 0);
                        size = (((offset.dx * 100) / 545) - 8.5);
                        waistwidth = size;
                        inch = (waistwidth / 2.54);
                        // alignmentwidth += 0.05;
                        // waistwidth += 1;
                        // inch = waistwidth / 2.5;
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

  Widget iconCameraSelected() => JustTheTooltip(
        controller: selectcameraTooltip,
        onShow: selectcameraTooltip.showTooltip,
        onDismiss: selectcameraTooltip.hideTooltip,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _isRearCameraSelected
                ? '???????????????????????????????????????????????????????????????????????????????????????????????????????????????'
                : '???????????????????????????????????????????????????????????????????????????????????????????????????????????????',
            style: const TextStyle(
              fontFamily: 'FC-Minimal-Regular',
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Image.asset(
              'images/switch_camera.png',
              color: Colors.white,
              scale: 12,
            ),
            onTap: () {
              setState(() {
                queryData = MediaQuery.of(context);
                var screen = queryData.size.height;
                print('screen ==== ${screen.toString()}');
                initCamera(cameras[_isRearCameraSelected ? 0 : 1]);
                _isRearCameraSelected = !_isRearCameraSelected;
              });
            },
          ),
        ),
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
                isMan: isMan ? true : false,
              ),
            )),
            (route) => false);
        _controller.setFlashMode(FlashMode.auto);
        setState(() {
          _ondelay();
          flash_on = false;
          flash_off = false;
        });
      }
    });
  }

  void _showAlertDialog(
    bool isAction,
    AssetImage icon,
    BuildContext context,
    String textTitle,
    String textContent,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: !isAction
            ? Column(
                children: [
                  Row(
                    children: [
                      ImageIcon(icon),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        textTitle,
                        style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: 20.0,
                          color: Colors.black45,
                          fontFamily: 'FC-Minimal-Regular',
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 5,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )
            : null,
        content: Text(
          textContent,
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontSize: 20.0,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
          textAlign: TextAlign.center,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
              isDefaultAction: !isAction,
              onPressed: () {
                if (isAction) {
                  Navigator.pop(context);
                  setState(() {
                    isMan = true;

                    if (isMan) {
                      size = (((offset.dx - 73.2) * 100 / widget.screenheight) /
                              2.08) *
                          2;
                    } else {
                      size = (((offset.dx - 73.2) * 100 / widget.screenheight) /
                              2.79) *
                          2;
                    }
                    waistwidth = size + 26;
                    inch = (waistwidth / 2.54);
                  });

                  _showAlertDialog(
                      false,
                      const AssetImage('images/man.png'),
                      context,
                      '??????????????????????????????????????????',
                      '?????????????????????????????????????????????????????????????????????????????????????????????\n 40 ??????.???????????? 15 ????????????????????????????????????');
                } else {
                  // Future.delayed(const Duration(milliseconds: 2000), () {
                  //   controller.showTooltip();
                  //   Future.delayed(const Duration(milliseconds: 4000), () {
                  //     setState(() {
                  //       controller.hideTooltip();
                  //       Future.delayed(const Duration(milliseconds: 1000), () {
                  //         selectcameraTooltip.showTooltip();
                  //         Future.delayed(const Duration(milliseconds: 4000),
                  //             () {
                  //           setState(() {
                  //             selectcameraTooltip.hideTooltip();
                  //           });
                  //         });
                  //       });
                  //     });
                  //   });
                  // });

                  Navigator.pop(context);
                }
              },
              child: isAction
                  ? const Text(
                      '???????????????',
                      style: TextStyle(color: Colors.red),
                    )
                  : const Text(
                      'OK',
                      style: TextStyle(color: Colors.blue),
                    )),
          if (isAction)
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                isMan = false;
                if (isMan) {
                  size =
                      (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.1) *
                          2;
                } else {
                  size = (((offset.dx - 73.2) * 100 / widget.screenheight) /
                          2.79) *
                      2;
                }
                waistwidth = size + 23;
                inch = (waistwidth / 2.54);
                _showAlertDialog(
                    false,
                    const AssetImage('images/woman.png'),
                    context,
                    '???????????????????????????????????????',
                    '?????????????????????????????????????????????????????????????????????????????????????????????\n 30 ??????.???????????? 12 ????????????????????????????????????');
              },
              child: const Text(
                '????????????',
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      ),
    );
  }

  void _showtDialog(
    AssetImage icon,
    BuildContext context,
    String textTitle,
    String textContent,
  ) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                ImageIcon(icon),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  textTitle,
                  style: const TextStyle(
                    overflow: TextOverflow.clip,
                    fontSize: 20.0,
                    color: Colors.black45,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 5,
              color: Colors.black54,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        content: Text(
          textContent,
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontSize: 20.0,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
          textAlign: TextAlign.center,
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              )),
        ],
      ),
    );
  }
}
