import 'package:flutter/material.dart';

class Camera2 extends StatefulWidget {
  const Camera2({Key? key}) : super(key: key);

  @override
  State<Camera2> createState() => _Camera2State();
}

class _Camera2State extends State<Camera2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return Container(
      color: Colors.green,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              'images/switch_camera.png',
              color: Colors.greenAccent,
              width: 150,
              height: 150,
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
                  child: Container(
                    
                  ),
                ),
                // Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, top: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      // ignore: unnecessary_const
                      child: const Text(
                        'x',
                        style: TextStyle(color: Colors.black),
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
                        value: 10,
                        min: 1,
                        max: 100,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white30,
                        onChanged: (value) async {},
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
}
