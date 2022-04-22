
import 'package:flutter/material.dart';

class MeasureFootSize extends StatefulWidget {
  const MeasureFootSize({Key? key}) : super(key: key);

  @override
  State<MeasureFootSize> createState() => _MeasureFootSizeState();
}

class _MeasureFootSizeState extends State<MeasureFootSize> {
    Offset position = const Offset(0.0, 0.0);
  late AssetImage apple;
  AssetImage _imageToShow = const AssetImage('images/belt.png');
    @override
  void initState() {
    super.initState();
    position = const Offset(1.0, 2.0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable<AssetImage>(
        data: _imageToShow,
        child: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _imageToShow,
            ),
          ),
          child: const Center(
            child: Text('widget.label',
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            position = const Offset(2.0, 3.0);
          });
        },
        onDragStarted: () {
          setState(() {
            print('drag started');
            _imageToShow =  const AssetImage('images/image3.png');
         //   return _imageToShow;
          });
        },
        feedback: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _imageToShow,
            ),
          ),
          child: const Center(
            child: Text(' widget.label',
              style: TextStyle(
                color: Colors.black,
                decoration: TextDecoration.none,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
