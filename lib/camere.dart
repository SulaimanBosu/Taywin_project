// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:taywin_project/measurement_results.dart';

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
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    var camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Container(
      color: Colors.black,
      width: screenwidth,
      height: screenwidth,
      child: Center(
        child: Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_controller),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _initcontroler,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        _cameraWidget(context),
                      ],
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        iconCamera(),
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
