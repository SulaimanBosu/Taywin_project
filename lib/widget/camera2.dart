import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_ruler/flutter_scale_ruler.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rulers/rulers.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:taywin_project/main.dart';
import 'package:taywin_project/utility/screen_size.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:taywin_project/widget/measurement_results.dart';

class Camera2 extends StatefulWidget {
  const Camera2({
    Key? key,
    required this.screenwidth,
    required this.screenheight,
    required this.type,
  }) : super(key: key);

  final String type;
  final double screenwidth;
  final double screenheight;

  @override
  State<Camera2> createState() => _Camera2State();
}

class _Camera2State extends State<Camera2> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initcontroler;
  bool _isRearCameraSelected = true;
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;

  double alignment = 2.4699999988300005;
  double sizeheight = 25.0;
  bool isColor = false;
  bool isType = false;
  late Timer timer;
  late double waistwidth;
  late double inch = waistwidth / 2.5;

  bool flash_on = false;
  bool flash_off = false;
  late double size;
  late Size sizeScreen;
  late double scale;
  final controller = JustTheController();
  final selectcameraTooltip = JustTheController();
  bool _istooltip = true;
  bool _isCameraPermissionGranted = false;

  ScaleValue? _scaleValue;
  ScaleValue? _scaleValueCms;

  getPermissionStatus() async {
    var status = await Permission.camera.status;
    var microphone = await Permission.microphone.status;

    if (status.isGranted && microphone.isGranted) {
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
        await Permission.microphone.request();
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
    super.initState();
  }

  void type() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        initCamera(cameras[0]);
        isType = true;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: !_isCameraPermissionGranted
          ? Container(
              color: Colors.black,
            )
          : content(),
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
                    alignment: AlignmentDirectional.center,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          _cameraWidget(context),
                          icon(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment(-0.22, alignment),
                            width: screenwidth * 0.65,
                            height: screenheight * 0.14,
                            // color: Colors.red,
                            child: Row(
                              children: List.generate(
                                150 ~/ 10,
                                (index) => Expanded(
                                  child: Container(
                                    color: index % 2 == 0
                                        ? Colors.transparent
                                        : isColor
                                            ? Colors.white
                                            : Colors.blue,
                                    height: 4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenheight * 0.5,
                          ),
                          Container(
                            alignment: const Alignment(0, 0.24),
                            width: screenwidth * 0.62,
                            height: screenheight * 0.257,
                            // color: Colors.red,
                            child: const Divider(
                              indent: 8,
                             // endIndent: 8,
                              thickness: 5,
                              height: 5,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  action_button(context),
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
            ),
          );
        }
      },
    );
  }

  Widget content() {
    return Container(
      child: Stack(
        children: [
          newContent(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 30),
                    height: screenheight * 0.68,
                    child: SfLinearGauge(
                      minorTicksPerInterval: 4,
                      interval: 5,
                      minorTickStyle:
                          const LinearTickStyle(color: Colors.white),
                      majorTickStyle: const LinearTickStyle(
                        length: 10,
                        color: Colors.red,
                      ),
                      axisTrackStyle: const LinearAxisTrackStyle(
                        borderColor: Colors.white,
                      ),
                      axisLabelStyle: const TextStyle(color: Colors.white),
                      orientation: LinearGaugeOrientation.vertical,
                      minimum: 0,
                      maximum: 30,
                      axisTrackExtent: 0,
                      markerPointers: <LinearMarkerPointer>[
                        LinearShapePointer(
                          value: sizeheight,
                          color: Colors.blue,
                          onChanged: (double value) {
                            setState(() {
                              value = sizeheight;
                            });
                          },
                        ),
                      ],
                      barPointers: [
                        LinearBarPointer(
                          value: sizeheight,
                          color: Colors.red,
                        )
                      ],
                      ranges: const <LinearGaugeRange>[
                        LinearGaugeRange(
                            startValue: 0, endValue: 20.5, color: Colors.green),
                        LinearGaugeRange(
                            startValue: 20.6,
                            endValue: 28.6,
                            color: Colors.blue)
                      ],
                    ),
                  ),
                ],
              )

              // Container(
              //   width: screenwidth,
              //   height: screenheight,
              //   child: Center(
              //     child: ListView.builder(
              //           itemCount: 1,
              //           //physics: NeverScrollableScrollPhysics(),
              //           scrollDirection: Axis.vertical,
              //           itemBuilder: (context1, index) {
              //             return ScaleRuler.lengthMeasurement(
              //               maxValue: 29,
              //               minValue: 20,
              //               backgroundColor: Colors.transparent,
              //               sliderActiveColor: Colors.green[500],
              //               sliderInactiveColor: Colors.greenAccent,
              //               onChanged: (
              //                 ScaleValue? scaleValue,
              //                 Axis? vertical
              //               ) {
              //                 setState(() {
              //                   _scaleValueCms = scaleValue;
              //                 });
              //                 print("${scaleValue?.cms} cms");
              //               },
              //             );
              //           }),
              //     ),

              // ),

              // ScaleRuler.lengthMeasurement(
              //   maxValue: 29,
              //   minValue: 20,
              //   backgroundColor: Colors.transparent,
              //   sliderActiveColor: Colors.green[500],
              //   sliderInactiveColor: Colors.greenAccent,
              //   onChanged: (
              //     ScaleValue? scaleValue,
              //     Axis? scrollDirection
              //   ) {
              //     setState(() {
              //       _scaleValueCms = scaleValue;
              //     });
              //     print("${scaleValue?.cms} cms");
              //   },
              // ),
              // const SizedBox(
              //   height: 20.0,
              // ),
              // Text(
              //   "${_scaleValueCms?.cms ?? "0"} cms",
              //   style: const TextStyle(fontSize: 18.0),
              // ),

              // Container(
              //   padding: const EdgeInsets.only(left: 10, top: 50),
              //   height: 650,
              //   margin: const EdgeInsets.only(top: 1.0),
              //   alignment: Alignment.centerLeft,
              //   child: RulerWidget(
              //     scaleBackgroundColor: Colors.transparent,
              //     height: 300,
              //     largeScaleBarsInterval: 1,
              //     smallScaleBarsInterval: 0,
              //     lowerIndicatorLimit: 0,
              //     lowerMidIndicatorLimit: 0,
              //     upperMidIndicatorLimit: 0,
              //     upperIndicatorLimit: 0,
              //     barsColor: Colors.white,
              //     inRangeBarColor: Colors.green,
              //     behindRangeBarColor: Colors.grey,
              //     outRangeBarColor: Colors.red,
              //     axis: Axis.vertical,
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              80.0,
              16.0,
              100.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(),
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // ignore: unnecessary_const
                      child: Text(
                        '${sizeheight.toStringAsFixed(1)} ซม.',
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 14.0,
                          fontFamily: 'FC-Minimal-Regular',
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Container(
                      height: 30,
                      child: Slider(
                        value: sizeheight,
                        min: 20.6, // 2,
                        max: 28.6, // 4.8
                        activeColor: Colors.blue,
                        inactiveColor: Colors.white30,
                        onChanged: (value) async {
                          setState(() {
                            if (alignment >= 3.8999999974) {
                              MyStyle().showBasicsFlash(
                                  context: context,
                                  text: 'ลดขนาดต่ำสุดแล้ว',
                                  flashStyle: FlashBehavior.fixed,
                                  duration: const Duration(seconds: 2));
                            } else if (alignment <= 1.3) {
                              MyStyle().showBasicsFlash(
                                  context: context,
                                  text: 'เพิ่มขนาดสูงสุดแล้ว',
                                  flashStyle: FlashBehavior.fixed,
                                  duration: const Duration(seconds: 2));
                            }
                            //  sizeheight = 28.6 - (value * 100 / 35) + 5.7; 6.15384615
                            sizeheight = value;
                           // ค่าที่ตั้งค่าของสัดส่วนของขนาด
                            alignment = (28.6 - value) / 3.07692308 + 1.3;
                            debugPrint('value =========>>>>> $value');
                            debugPrint(
                                'alignment =========>>>>> $alignment');
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget action_button(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: screenheight * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          // Container(
          //   alignment: const Alignment(0, -1),
          //   width: screenwidth * 0.3,
          //   height: screenheight * 0.05,
          //   child: _textcontainer(),
          // ),
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

  Widget _textcontainer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(5)),
      width: screenwidth * 0.2,
      height: screenheight * 0.03,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${sizeheight.toStringAsFixed(1)} ซม.',
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
                width: isType ? 0 : waistwidth,
                height: isType ? sizeheight : 0,
                type: widget.type,
                sex: true,
              ),
            )),
            (route) => false);
        _controller.setFlashMode(FlashMode.auto);
        setState(() {
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

                  _showAlertDialog(
                      false,
                      const AssetImage('images/man.png'),
                      context,
                      'วัดรอบเอวบุรุษ',
                      'กรุณาถือกล้องให้ห่างจากตัวบุคคล\n 40 ซม.หรือ 15 นิ้วเท่านั้น');
                } else {
                  Navigator.pop(context);
                }
              },
              child: isAction
                  ? const Text(
                      'บุรุษ',
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
                _showAlertDialog(
                    false,
                    const AssetImage('images/woman.png'),
                    context,
                    'วัดรอบเอวสตรี',
                    'กรุณาถือกล้องให้ห่างจากตัวบุคคล\n 30 ซม.หรือ 12 นิ้วเท่านั้น');
              },
              child: const Text(
                'สตรี',
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      ),
    );
  }
}
