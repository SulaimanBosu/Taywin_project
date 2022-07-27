import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_scale_ruler/flutter_scale_ruler.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:taywin_project/main.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:taywin_project/utility/size.dart';
import 'package:taywin_project/widget/measurement_results.dart';
import 'package:wakelock/wakelock.dart';

class Camera3 extends StatefulWidget {
  const Camera3({
    Key? key,
    required this.screenwidth,
    required this.screenheight,
    required this.type,
  }) : super(key: key);

  final String type;
  final double screenwidth;
  final double screenheight;

  @override
  State<Camera3> createState() => _Camera3State();
}

class _Camera3State extends State<Camera3> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initcontroler;
  bool _isRearCameraSelected = true;
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;

  double alignment = -3.096167232630559;
  double alignment2 = -3.9342867984586034;
  double alignment3 = -3.5831924301974327;
  double alignmentvalue = -0.14;
  double textalignment = -0.118;
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
  Offset offset = const Offset(480, 0.0);
  late Offset _offset;
  bool isMan = false;
  late MediaQueryData queryData;
  double indent_a = 0;
  double endIndent_b = 0;
  double endIndent = 0;
  double sizeUp = 26;
  late List<String> sizes = [];
  late String sizeTH;
  late String sizeUS;
  late String sizeUK;

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
      // type();
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
    type();
    getPermissionStatus();
    super.initState();
    // widget.screenheight > 750
    //     ? _offset = const Offset(0, 212.00911458333323)
    //     : _offset = const Offset(0, 161.36881510416683);

    _offset = Offset(-0.5, widget.screenheight * 0.22);

    // widget.screenheight > 730 ? 212.00911458333323 : 162
    Wakelock.enable();
  }

  void type() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        initCamera(cameras[0]);
        isType = true;
        Wakelock.enable();
        delaydialog('กรุณาเลือกเพศก่อนทำการวัด');
      });
      if (isMan) {
        setState(() {
          sizes = Sizes().man(sizeheight);
          sizeTH = sizes[0];
          sizeUS = sizes[1];
          sizeUK = sizes[2];
        });
      } else {
        setState(() {
          sizes = Sizes().woman(sizeheight);
          sizeTH = sizes[0];
          sizeUS = sizes[1];
          sizeUK = sizes[2];
        });
      }
    } else if (widget.type == MyStyle().waistline) {
      setState(() {
        Wakelock.enable();
        initCamera(cameras[1]);
        delaydialog('กรุณาเลือกเพศและอ่านคำแนะนำก่อนทำการวัดรอบเอว');
        isType = false;
        // if (isMan) {
        //   size = (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.08) * 2 + 2.54;
        // } else {
        //   size = (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.79) * 2;
        // }

        if (isMan) {
          size = (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.08) * 2 +
              2.54;
        } else {
          size = (((offset.dx - 73.2) * 100 / widget.screenheight) / 2.79) * 2;
        }
        print('screenwidth ==== ${widget.screenheight.toString()}');

        waistwidth = size + sizeUp;
        // waistwidth = size + 33;
        inch = (waistwidth / 2.54);
      });
    } else {
      print('เกิดผิดพลาด');
    }
  }

  void delaydialog(String advice) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _showAlertDialog(true, const AssetImage('images/man.png'), context,
            'เลือกเพศ', advice);
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _ondelay() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        Navigator.pop(context);
      });
    });
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

  Widget content() {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Stack(
        children: [
          newContent(),
          isType
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: 20, left: screenwidth * 0.167),
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
                            axisLabelStyle:
                                const TextStyle(color: Colors.white),
                            orientation: LinearGaugeOrientation.vertical,
                            minimum: 0,
                            maximum: 30,
                            axisTrackExtent: 0,
                            // markerPointers: <LinearMarkerPointer>[
                            //   LinearShapePointer(
                            //     value: sizeheight,
                            //     color: Colors.blue,
                            //     onChanged: (double value) {
                            //       setState(() {
                            //         value = sizeheight;
                            //       });
                            //     },
                            //   ),
                            // ],
                            barPointers: [
                              LinearBarPointer(
                                value: sizeheight,
                                color: Colors.blue,
                              )
                            ],
                            // ranges: const <LinearGaugeRange>[
                            //   // LinearGaugeRange(
                            //   //     startValue: 0, endValue: 20.5, color: Colors.red),
                            //   LinearGaugeRange(
                            //       startValue: 0,
                            //       endValue: 30,
                            //       color: Colors.blue)
                            // ],
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Container(),
          isType
              ? Padding(
                  padding: EdgeInsets.fromLTRB(
                    16.0,
                    screenheight * 0.08,
                    screenwidth * 0.13,
                    screenheight * 0.126,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(),
                      ),
                      // Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenwidth >= 700 && screenheight >= 750
                                    ? screenheight * 0.05
                                    : screenheight >= 750
                                        ? screenheight * 0.05
                                        : screenheight * 0.03),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                // ignore: unnecessary_const
                                child: Text(
                                  '$sizeTH (EU)',
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14.0,
                                    fontFamily: 'FC-Minimal-Regular',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenwidth >= 700
                                    ? screenheight * 0.05
                                    : screenheight >= 750
                                        ? screenheight * 0.05
                                        : screenheight * 0.03),
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
                        ],
                      ),

                      Expanded(
                        child: Stack(
                          // alignment: Alignment(-0.5, 0),
                          children: [
                            RotatedBox(
                              quarterTurns: 3,
                              child: Container(
                                height: screenwidth >= 700 ? 50 : 30,
                                child: Slider(
                                  //  label: "${sizeTH.toString()}",
                                  //  divisions: 60,
                                  value: sizeheight,
                                  min: 0.0, // 2,
                                  max: 30.0, // 4.8
                                  activeColor: Colors.blue,
                                  inactiveColor: Colors.black12,
                                  onChanged: (value) async {
                                    setState(() {
                                      // if (alignment >= 3.9499999974000004) {
                                      //   MyStyle().showBasicsFlash(
                                      //     context: context,
                                      //     text: 'ลดขนาดต่ำสุดแล้ว',
                                      //     flashStyle: FlashBehavior.fixed,
                                      //     duration: const Duration(seconds: 2),
                                      //   );
                                      // } else if (alignment <= 1.35) {
                                      //   MyStyle().showBasicsFlash(
                                      //     context: context,
                                      //     text: 'เพิ่มขนาดสูงสุดแล้ว',
                                      //     flashStyle: FlashBehavior.fixed,
                                      //     duration: const Duration(seconds: 2),
                                      //   );
                                      // }
                                      if (isMan) {
                                        sizes = Sizes().man(value);
                                        sizeTH = sizes[0];
                                        sizeUS = sizes[1];
                                        sizeUK = sizes[2];
                                      } else {
                                        sizes = Sizes().woman(value);
                                        sizeTH = sizes[0];
                                        sizeUS = sizes[1];
                                        sizeUK = sizes[2];
                                      }
                                      //  sizeheight = 28.6 - (value * 100 / 35) + 5.7; 6.15384615
                                      // if (sizeheight >= 20) {
                                      //   sizeheight = value;
                                      //   // ค่าที่ตั้งค่าของสัดส่วนของขนาด
                                      //   alignment =
                                      //       (11 - sizeheight) / 3.07692308 +
                                      //           1.5;
                                      //   alignment2 =
                                      //       (20 - sizeheight) / 2.58 - 2;
                                      //   alignment3 =
                                      //       (20 - sizeheight) / 2.65 - 1.7;
                                      //   debugPrint(
                                      //       'sizeheight =========>>>>> $sizeheight');
                                      //   debugPrint(
                                      //       'alignment =========>>>> $alignment');
                                      //   debugPrint(
                                      //       'alignment2 =========>>>> $alignment2');
                                      //   debugPrint(
                                      //       'alignment3 =========>>>> $alignment3');
                                      //   alignmentvalue =
                                      //       (28.6 - value) / 4.232 - 0.99;
                                      //   textalignment =
                                      //       (28.6 - value) / 4.13008 - 0.99;
                                      //   debugPrint(
                                      //       'text =========>>>> $textalignment');

                                      //   print(
                                      //       'offset.dy ======> ${_offset.dy.toString()}');
                                      //   print(
                                      //       'screenheight ======> ${screenheight.toString()}');
                                      //   print(
                                      //       'screenwidth ======> ${screenwidth.toString()}');
                                      // } else
                                      if (value <= 20) {
                                        value = 20;
                                        sizeheight = 20;
                                        alignment = -1.4177650555408925;
                                      } else {
                                        sizeheight = value;
                                        // ค่าที่ตั้งค่าของสัดส่วนของขนาด
                                        alignment =
                                            (11 - sizeheight) / 3.07692308 +
                                                1.5;
                                        alignment2 =
                                            (20 - sizeheight) / 2.58 - 2;
                                        alignment3 =
                                            (20 - sizeheight) / 2.65 - 1.7;
                                        debugPrint(
                                            'sizeheight =========>>>>> $sizeheight');
                                        debugPrint(
                                            'alignment =========>>>> $alignment');
                                        debugPrint(
                                            'alignment2 =========>>>> $alignment2');
                                        debugPrint(
                                            'alignment3 =========>>>> $alignment3');
                                        alignmentvalue =
                                            (28.6 - value) / 4.232 - 0.99;
                                        textalignment =
                                            (28.6 - value) / 4.13008 - 0.99;
                                        debugPrint(
                                            'text =========>>>> $textalignment');

                                        print(
                                            'offset.dy ======> ${_offset.dy.toString()}');
                                        print(
                                            'screenheight ======> ${screenheight.toString()}');
                                        print(
                                            'screenwidth ======> ${screenwidth.toString()}');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
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
                          isType ? icon() : Container(),
                          isType ? typegender() : Container(),
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
                      isType
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: screenheight * 0.5,
                                ),
                                Container(
                                  alignment: const Alignment(0, 0.77),
                                  width: screenwidth * 0.67,
                                  height: screenheight * 0.257,
                                  // color: Colors.red,
                                  child: const Divider(
                                    //indent: 18,
                                    // endIndent: screenwidth <= 362.0 ? 8 : 0,
                                    thickness: 5,
                                    height: 5,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      isType
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: screenwidth >= 700
                                          ? 0
                                          : screenwidth * 0.07),
                                  alignment: Alignment(0.22, alignment),
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
                                // Container(
                                //   alignment: Alignment(0, alignment2),
                                //   width: screenwidth * 0.05,
                                //   height: screenheight * 0.14,
                                //   // color: Colors.red,
                                //   child: CustomPaint(
                                //     painter: TrianglePainter(
                                //       strokeColor: Colors.blue,
                                //       strokeWidth: 10,
                                //       paintingStyle: PaintingStyle.fill,
                                //     ),
                                //     child: Container(
                                //       height: 20,
                                //       width: 20,
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   alignment: Alignment(-1.92, alignment3),
                                //   width: screenwidth * 0.10,
                                //   height: screenheight * 0.15,
                                //   // color: Colors.red,
                                //   child: Container(
                                //     //  margin: EdgeInsets.only(top: 0),
                                //     color: Colors.blue,
                                //     width: 35,
                                //     height: 25,
                                //     child: const Text(
                                //       'เลื่อน',
                                //       style: TextStyle(color: Colors.white),
                                //     ),
                                //   ),
                                // ),

                                // Container(
                                //   // padding: const EdgeInsets.only(bottom: 20),
                                //   // margin: EdgeInsets.only(bottom: 20),
                                //   alignment: Alignment(0, alignment),

                                //   child: CustomPaint(
                                //     painter: TrianglePainter(
                                //       strokeColor: Colors.blue,
                                //       strokeWidth: 10,
                                //       paintingStyle: PaintingStyle.fill,
                                //     ),
                                //     child: Container(
                                //       height: 20,
                                //       width: 20,
                                //     ),
                                //   ),
                                // ),
                                // Container(
                                //   alignment: Alignment(1.3, alignment),
                                //   child: Container(
                                //    //  margin: EdgeInsets.only(top: 0),
                                //     color: Colors.blue,
                                //     width: 35,
                                //     height: 25,
                                //     child: const Text(
                                //       'เลื่อน',
                                //       style: TextStyle(color: Colors.white),
                                //     ),
                                //   ),
                                // ),
                              ],
                            )
                          : divider(),
                      isType ? Container() : _isGestureDetector(),
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

  Widget typegender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              Wakelock.enable();
              isMan = !isMan;
              alignment = (11 - sizeheight) / 3.07692308 + 1.5;
              alignment2 = (20 - sizeheight) / 2.58 - 2;
              alignment3 = (20 - sizeheight) / 2.65 - 1.7;
              // isMan
              //     ? _showAlertDialog(
              //         false,
              //         const AssetImage('images/man.png'),
              //         context,
              //         'วัดขนาดเท้าบุรุษ',
              //         'กรุณาถือกล้องให้ห่างจากเท้าในระยะ 40 ซม.หรือ 16 นิ้วเท่านั้น')
              //     : _showAlertDialog(
              //         false,
              //         const AssetImage('images/woman.png'),
              //         context,
              //         'วัดขนาดเท้าสตรี',
              //         'กรุณาถือกล้องให้ห่างจากเท้าในระยะ 40 ซม.หรือ 16 นิ้วเท่านั้น');

              if (isMan) {
                sizes = Sizes().man(sizeheight);
                sizeTH = sizes[0];
                sizeUS = sizes[1];
                sizeUK = sizes[2];
              } else {
                sizes = Sizes().woman(sizeheight);
                sizeTH = sizes[0];
                sizeUS = sizes[1];
                sizeUK = sizes[2];
              }
            });
          },
          child: Center(
            child: Container(
              margin: const EdgeInsets.only(right: 20, bottom: 10),
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
                            ? 'กดปุ่มนี้หากต้องการสลับไปวัดเท้าเอวสตรี'
                            : 'กดปุ่มนี้หากต้องการสลับไปวัดเท้าบุรุษ',
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
                    isMan ? 'วัดเท้าบุรุษ' : 'วัดเท้าสตรี',
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
        ),
      ],
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

  Widget divider() {
    return Stack(
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
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget isGestureDetector() {
    return Positioned(
      top: _offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            Wakelock.enable();
            _offset = Offset(0, _offset.dy + details.delta.dy);
            // _offset = Offset(0, _offset.dy + details.delta.dy);
            if (_offset.dy <= (widget.screenheight * 14.1 / 100)) {
              _offset = Offset(0, widget.screenheight * 14.1 / 100);
              // MyStyle().showBasicsFlash(
              //   context: context,
              //   text: 'เพิ่มขนาดสูงสุดแล้ว',
              //   flashStyle: FlashBehavior.fixed,
              //   duration: const Duration(seconds: 2),
              // );
            } else if (_offset.dy >= widget.screenheight * 32 / 100) {
              _offset = Offset(0, widget.screenheight * 32 / 100);
              // MyStyle().showBasicsFlash(
              //   context: context,
              //   text: 'ลดขนาดต่ำสุดแล้ว',
              //   flashStyle: FlashBehavior.fixed,
              //   duration: const Duration(seconds: 2),
              // );
            }

            // if (screenheight > 1100) {
            //   sizeheight = (((screenheight - _offset.dy)) / 25) - 9.93;
            // } else if (screenheight > 1020 && screenwidth > 700.0) {
            //   sizeheight = (((screenheight - _offset.dy)) / 22.95) - 9.73;
            // } else if (screenheight > 816) {
            //   sizeheight =
            //       (((screenheight - _offset.dy) - screenwidth) / 21.95) + 12.07;
            // } else if (screenheight > 750) {
            //   sizeheight = (screenheight - _offset.dy) / 16.85 - 9.7;
            // } else {
            //   sizeheight = (screenheight - _offset.dy) / 16.2 - 10.2;
            //  }

            if (screenheight > 1020 && screenwidth > 700.0) {
              sizeheight = (((screenheight * 0.0001 / 100) -
                          (_offset.dy * 0.0001 / 100) * 10000) *
                      4.375) +
                  34.9;
            } else if (screenheight >= 980) {
              sizeheight = (((screenheight * 0.0001 / 100) -
                          (_offset.dy * 0.0001 / 100) * 10000) *
                      5.35) +
                  35.9;
            } else if (screenheight <= 742) {
              sizeheight = (((screenheight * 0.0001 / 100) -
                          (_offset.dy * 0.0001 / 100) * 10000) *
                      6.1) +
                  34.9;
            } else {
              sizeheight = (((screenheight * 0.0001 / 100) -
                          (_offset.dy * 0.0001 / 100) * 10000) *
                      4.51) +
                  34.8;
            }

            // sizeheight = widget.screenheight * 5 / 140 - _offset.dy / 8;

            //ค่าใกล้เคียงสุด  // sizeheight =
            //     (((((screenheight * screenwidth) * 90 / _offset.dy * 30 / 100) /
            //                     100) /
            //                 _offset.dy) /
            //             21.95) +
            //         12.07;

            //  sizeheight =
            //       14.3 +(((screenheight * 918 / 1000 +((screenheight * (918  + _offset.dy / 100)) * 30 / 100)) / _offset.dy)/1.47) / 93.1;

            if (isMan) {
              sizes = Sizes().man(sizeheight);
              sizeTH = sizes[0];
              sizeUS = sizes[1];
              sizeUK = sizes[2];
            } else {
              sizes = Sizes().woman(sizeheight);
              sizeTH = sizes[0];
              sizeUS = sizes[1];
              sizeUK = sizes[2];
            }
            print('sizeheight ======> ${sizeheight.toString()}');
            print('offset.dy ======> ${_offset.dy.toString()}');
            print('screenheight ======> ${screenheight.toString()}');
            print('screenwidth ======> ${screenwidth.toString()}');
          });
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 55),
              // alignment: Alignment(-0.22, alignment),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                //alignment: Alignment(0, 0),
                child: CustomPaint(
                  painter: TrianglePainter(
                    strokeColor: Colors.blue,
                    strokeWidth: 10,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  child: Container(
                    height: 20,
                    width: 20,
                  ),

                  //const Text(
                  //     'เลื่อน',
                  //     style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              // alignment: Alignment(1.3, textalignment),
              child: Container(
                // margin: EdgeInsets.only(top: 0),
                color: Colors.blue,
                width: 35,
                height: 25,
                child: const Text(
                  'เลื่อน',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget typeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              Wakelock.enable();
              isMan = !isMan;
              isMan
                  ? _showAlertDialog(
                      false,
                      const AssetImage('images/man.png'),
                      context,
                      'วัดรอบเอวบุรุษ',
                      'กรุณาถือกล้องให้ห่างจากตัวบุคคล\n 40 ซม.หรือ 15 นิ้วเท่านั้น')
                  : _showAlertDialog(
                      false,
                      const AssetImage('images/woman.png'),
                      context,
                      'วัดรอบเอวสตรี',
                      'กรุณาถือกล้องให้ห่างจากตัวบุคคล\n 30 ซม.หรือ 12 นิ้วเท่านั้น');
              if (isMan) {
                size = (((offset.dx - 73.2) * 100 / screenwidth) / 2.08) * 2 +
                    2.54;
              } else {
                size = (((offset.dx - 73.2) * 100 / screenwidth) / 2.79) * 2;
              }

              waistwidth = size + sizeUp;
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
                          ? 'กดปุ่มนี้หากต้องการสลับไปวัดรอบเอวสตรี'
                          : 'กดปุ่มนี้หากต้องการสลับไปวัดรอบเอวบุรุษ',
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
                  isMan ? 'วัดรอบเอวบุรุษ' : 'วัดรอบเอวสตรี',
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

  Widget _isGestureDetector() {
    return Positioned(
      left: offset.dx,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            Wakelock.enable();
            offset = Offset(offset.dx + details.delta.dx, 0);
            if (offset.dx >= (screenwidth * 91 / 100)) {
              offset = Offset(screenwidth * 91 / 100, 0);
              MyStyle().showBasicsFlash(
                context: context,
                text: 'เพิ่มขนาดสูงสุดแล้ว',
                flashStyle: FlashBehavior.fixed,
                duration: const Duration(seconds: 2),
              );
            } else if (offset.dx <= screenwidth * 30 / 100) {
              offset = Offset(screenwidth * 30 / 100, 0);
              MyStyle().showBasicsFlash(
                context: context,
                text: 'ลดขนาดต่ำสุดแล้ว',
                flashStyle: FlashBehavior.fixed,
                duration: const Duration(seconds: 2),
              );
            }
            //else {}
            if (isMan) {
              size =
                  (((offset.dx - 73.2) * 100 / screenwidth) / 2.08) * 2 + 2.54;
            } else {
              size = (((offset.dx - 73.2) * 100 / screenwidth) / 2.79) * 2;
            }
            waistwidth = size + sizeUp;
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

  Widget iconCameraSelected() => JustTheTooltip(
        controller: selectcameraTooltip,
        onShow: selectcameraTooltip.showTooltip,
        onDismiss: selectcameraTooltip.hideTooltip,
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            _isRearCameraSelected
                ? 'กดปุ่มนี้หากต้องการสลับไปใช้กล้องหน้า'
                : 'กดปุ่มนี้หากต้องการสลับไปใช้กล้องหลัง',
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

  Widget _textcontainer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(5)),
      width: screenwidth * 0.16,
      height: screenheight * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${waistwidth.toStringAsFixed(0)} ซม.',
            style: const TextStyle(
              color: Colors.green,
              fontSize: 14.0,
              fontFamily: 'FC-Minimal-Regular',
            ),
          ),
          const Text(' | '),
          Text(
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
                isMan: isMan ? true : false,
              ),
            )),
            (route) => false);
        _controller.setFlashMode(FlashMode.auto);
        setState(() {
          _ondelay();
          flash_on = false;
          flash_off = false;
          Wakelock.disable();
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
                  if (isType) {
                    isMan = true;
                    setState(() {
                      sizes = Sizes().man(sizeheight);
                      sizeTH = sizes[0];
                      sizeUS = sizes[1];
                      sizeUK = sizes[2];
                    });
                  } else {
                    setState(() {
                      isMan = true;

                      if (isMan) {
                        size =
                            (((offset.dx - 73.2) * 100 / screenwidth) / 2.08) *
                                    2 +
                                2.54;
                      } else {
                        size =
                            (((offset.dx - 73.2) * 100 / screenwidth) / 2.79) *
                                2;
                      }
                      waistwidth = size + sizeUp;
                      // waistwidth = size + 33;
                      inch = (waistwidth / 2.54);
                    });
                  }
                  if (isType) {
                  } else {
                    _showAlertDialog(
                        false,
                        const AssetImage('images/man.png'),
                        context,
                        'วัดรอบเอวบุรุษ',
                        'กรุณาถือกล้องให้ห่างจากตัวบุคคล\n 40 ซม.หรือ 15 นิ้วเท่านั้น');
                  }
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
                if (isType) {
                  isMan = false;
                  setState(() {
                    sizes = Sizes().woman(sizeheight);
                    sizeTH = sizes[0];
                    sizeUS = sizes[1];
                    sizeUK = sizes[2];
                  });
                } else {
                  isMan = false;
                  if (isMan) {
                    size =
                        (((offset.dx - 73.2) * 100 / screenwidth) / 2.08) * 2 +
                            2.54;
                  } else {
                    size =
                        (((offset.dx - 73.2) * 100 / screenwidth) / 2.79) * 2;
                  }
                  waistwidth = size + sizeUp;
                  // waistwidth = size + 33;
                  inch = (waistwidth / 2.54);
                  _showAlertDialog(
                      false,
                      const AssetImage('images/woman.png'),
                      context,
                      'วัดรอบเอวสตรี',
                      'กรุณาถือกล้องให้ห่างจากตัวบุคคล\n 30 ซม.หรือ 12 นิ้วเท่านั้น');
                }
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

  // void _showtDialog(
  //   AssetImage icon,
  //   BuildContext context,
  //   String textTitle,
  //   String textContent,
  // ) {
  //   showCupertinoModalPopup<void>(
  //     context: context,
  //     builder: (BuildContext context) => CupertinoAlertDialog(
  //       title: Column(
  //         children: [
  //           Row(
  //             children: [
  //               ImageIcon(icon),
  //               const SizedBox(
  //                 width: 5,
  //               ),
  //               Text(
  //                 textTitle,
  //                 style: const TextStyle(
  //                   overflow: TextOverflow.clip,
  //                   fontSize: 20.0,
  //                   color: Colors.black45,
  //                   fontFamily: 'FC-Minimal-Regular',
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const Divider(
  //             thickness: 1,
  //             height: 5,
  //             color: Colors.black54,
  //           ),
  //           const SizedBox(
  //             height: 10,
  //           ),
  //         ],
  //       ),
  //       content: Text(
  //         textContent,
  //         style: const TextStyle(
  //           overflow: TextOverflow.clip,
  //           fontSize: 20.0,
  //           color: Colors.black45,
  //           fontFamily: 'FC-Minimal-Regular',
  //         ),
  //         textAlign: TextAlign.center,
  //       ),
  //       actions: <CupertinoDialogAction>[
  //         CupertinoDialogAction(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text(
  //               'OK',
  //               style: TextStyle(color: Colors.blue),
  //             )),
  //       ],
  //     ),
  //   );
  // }
}
