import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MeasureFootSize extends StatefulWidget {
  const MeasureFootSize({Key? key}) : super(key: key);

  @override
  State<MeasureFootSize> createState() => _MeasureFootSizeState();
}

class _MeasureFootSizeState extends State<MeasureFootSize> {
    late CameraController controller;
    late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: CameraPreview(controller),
    );
  }
}
