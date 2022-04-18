// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison, avoid_unnecessary_containers, camel_case_types, avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:taywin_project/measurement_results.dart';
import 'dart:math' as math;

class OpenCamera extends StatefulWidget {
  const OpenCamera({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  final CameraDescription cameras;

  @override
  State<OpenCamera> createState() => _OpenCameraState();
}

class _OpenCameraState extends State<OpenCamera> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initcontroler;

  var isCameraReady = false;
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;

  @override
  void initState() {
    initCamera();
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
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
      body: FutureBuilder(
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
                            iconCamera(),
                          ],
                        ),
                        line2(
                            screenwidth: screenwidth,
                            screenheight: screenheight),
                        line(
                            screenwidth: screenwidth,
                            screenheight: screenheight),
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
          }),
    );
  }

  IconButton iconCamera() => IconButton(
        onPressed: () {
          captureImage(context);
        },
        icon: const Icon(
          Icons.camera_rounded,
          color: Colors.white,
        ),
        iconSize: 40,
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
                builder: (context) => MeasurementResults(image: imagefile))),
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

class line extends StatelessWidget {
  const line({
    Key? key,
    required this.screenwidth,
    required this.screenheight,
  }) : super(key: key);

  final double screenwidth;
  final double screenheight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(
            //   width: 83,
            // ),
            Row(
              children: [
                const SizedBox(
                  width: 45,
                ),
                Image.asset(
                  'images/Line1.png',
                  width: screenwidth * 0.01,
                  height: screenheight * 0.6,
                ),
              ],
            ),

            Image.asset(
              'images/Line2.png',
              height: screenwidth * 0.01,
              width: screenheight * 0.8,
            ),
          ],
        ),
      ],
    );
  }
}

class line2 extends StatefulWidget {
  const line2({
    Key? key,
    required this.screenwidth,
    required this.screenheight,
  }) : super(key: key);

  final double screenwidth;
  final double screenheight;

  @override
  State<line2> createState() => _line2State();
}

class _line2State extends State<line2> {
  double alignment_a = 0.7;
  double alignment_b = -0.9999999999999999;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment(alignment_a, alignment_b),
              children: [
                Column(
                  children: [
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Image.asset(
                      'images/Line3.png',
                      width: widget.screenwidth * 0.8,
                      height: widget.screenheight * 0.01,
                    ),
                  ],
                ),
                Column(
                  children: [
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    Image.asset(
                      'images/Line4.png',
                      width: widget.screenwidth * 0.01,
                      height: widget.screenwidth * 1.2,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    if (alignment_a >= 0.7 ||
                        alignment_b >= -0.9999999999999999) {
                      setState(() {
                        alignment_a += 0.1;
                        alignment_b -= 0.1;
                        print(
                            'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                        // width += 0.1;
                        // height += 0.001;
                      });
                    } else {
                      print(
                          'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                    }
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  child: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    if (alignment_a <= -0.19999999999999998 ||
                        alignment_b <= -0.10000000000000003) {
                      setState(() {
                        alignment_a -= 0.1;
                        alignment_b += 0.1;
                        print(
                            'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                        // width -= 0.01;
                        // height -= 0.001;
                      });
                    } else {
                      print(
                          'alignment_a ===> $alignment_a\n alignment_b ===> $alignment_b');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
