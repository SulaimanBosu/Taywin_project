import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rulers/rulers.dart';
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

  double alignment_e = -0.22000000000000003;
  double alignment_f = 1.0570809011803468; // 2,
  double sizeheight = 28.6;
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
                            alignment: Alignment(alignment_e, alignment_f),
                            width: screenwidth * 0.62,
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
                                            : Colors.green,
                                    height: 2,
                                  ),
                                ),
                              ),
                            ),

                            //  Divider(
                            //   indent: indent_c,
                            //   endIndent: endIndent_d,
                            //   thickness: 10,
                            //   color: isColor ? Colors.green : Colors.red,
                            // ),
                          ),
                          SizedBox(
                            height: screenheight * 0.5,
                          ),
                          Container(
                            alignment: const Alignment(0, 0.3),
                            width: screenwidth * 0.62,
                            height: screenheight * 0.257,
                            // color: Colors.red,
                            child: const Divider(
                              indent: 8,
                              endIndent: 8,
                              thickness: 5,
                              height: 5,
                              color: Colors.red,
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
    );
  }

  Widget content() {
    return Container(
      child: Stack(
        children: [
          newContent(),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Container(
          //       padding: const EdgeInsets.only(left: 10, top: 50),
          //       height: 650,
          //       margin: const EdgeInsets.only(top: 1.0),
          //       alignment: Alignment.centerLeft,
          //       child: RulerWidget(
          //         scaleBackgroundColor: Colors.transparent,
          //         height: 300,
          //         largeScaleBarsInterval: 30,
          //         smallScaleBarsInterval: 0,
          //         lowerIndicatorLimit: 20,
          //         lowerMidIndicatorLimit: 30,
          //         upperMidIndicatorLimit: 0,
          //         upperIndicatorLimit: 0,
          //         barsColor: Colors.white,
          //         axis: Axis.vertical,
          //       ),
          //     ),
          //   ],
          // ),
          Container(
            padding: const EdgeInsets.only(left: 45, top: 10),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'images/image10.png',
              // color: Colors.greenAccent,
              // width: 150,
              height: screenheight * 0.7,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16.0,
              80.0,
              16.0,
              80.0,
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
                      borderRadius: BorderRadius.circular(10.0),
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
                    quarterTurns: 5,
                    child: Container(
                      height: 30,
                      child: Slider(
                        value: alignment_f,
                        min: 1.0570809011803468, // 2,
                        max: 3.7686147023598, // 4.8
                        activeColor: Colors.green,
                        inactiveColor: Colors.white30,
                        onChanged: (value) async {
                          setState(() {
                            sizeheight = 28.6 - (value * 100 / 35) + 5.7;
                            // sizeheight = 28.6 - (value * 100 / 35) + 3;
                            alignment_f = value;
                            debugPrint('value =========>>>>> $value');
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
          Container(
            alignment: const Alignment(0, -1),
            width: screenwidth * 0.3,
            height: screenheight * 0.05,
            child: _textcontainer(),
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
