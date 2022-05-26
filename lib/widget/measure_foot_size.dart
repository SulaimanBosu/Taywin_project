// ignore_for_file: unused_field

import 'package:flutter/material.dart';

import 'package:vector_math/vector_math_64.dart' as vector;

class MeasureFootSize extends StatefulWidget {
  const MeasureFootSize({Key? key}) : super(key: key);

  @override
  State<MeasureFootSize> createState() => _MeasureFootSizeState();
}

class _MeasureFootSizeState extends State<MeasureFootSize> {
  Offset position = const Offset(0.0, 0.0);
  late AssetImage apple;
  final AssetImage _imageToShow = const AssetImage('images/belt.png');
  @override
  void initState() {
    super.initState();
    position = const Offset(1.0, 2.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Center(
      child: Text('${screenwidth.toString()} \n ${screenheight.toString()}'),
    );
    //CameraDistancePage();
  }
}

// class CameraDistancePage extends StatefulWidget {
//   const CameraDistancePage({Key? key}) : super(key: key);

//   @override
//   _CameraDistancePageState createState() => _CameraDistancePageState();
// }

// class _CameraDistancePageState extends State<CameraDistancePage> {
//   late ARKitController arkitController;
//   late vector.Vector3 lastPosition;
//   String distance = '0';

//   @override
//   void dispose() {
//     arkitController?.dispose();
//     super.dispose();/   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//       appBar: AppBar(
//         title: const Text('Camera Distance'),
//       ),
//       body: Stack(
//         children: [
//           ARKitSceneView(
//             enableTapRecognizer: true,
//             onARKitViewCreated: onARKitViewCreated,
//             showFeaturePoints: true,
//             showWorldOrigin: true,
//             worldAlignment: ARWorldAlignment.camera,
//           ),
//           Text(distance, style: Theme.of(context).textTheme.displaySmall),
//         ],
//       ));

//   void onARKitViewCreated(ARKitController arkitController) {
//     this.arkitController = arkitController;
//     this.arkitController.onARTap = (ar) {
//       final point =
//           ar.firstWhere((o) => o.type == ARKitHitTestResultType.featurePoint);
//       if (point != null) {
//         final position = vector.Vector3(
//           point.worldTransform.getColumn(3).x,
//           point.worldTransform.getColumn(3).y,
//           point.worldTransform.getColumn(3).z,
//         );
//         setState(() {
//           distance =
//               _calculateDistanceBetweenPoints(vector.Vector3.zero(), position);
//         });
//       }
//     };
//   }

//   String _calculateDistanceBetweenPoints(vector.Vector3 A, vector.Vector3 B) {
//     final length = A.distanceTo(B);
//     return '${(length * 100).toStringAsFixed(2)} cm';
//   }
// }
