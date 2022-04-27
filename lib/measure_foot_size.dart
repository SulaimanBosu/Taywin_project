// ignore_for_file: unused_field

import 'package:flutter/material.dart';

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
  }
}
