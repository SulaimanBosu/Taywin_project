// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class MeasurementResults extends StatefulWidget {
  final XFile image;
  const MeasurementResults({Key? key, required this.image}) : super(key: key);

  @override
  State<MeasurementResults> createState() => _MeasurementResultsState();
}

class _MeasurementResultsState extends State<MeasurementResults> {
  late XFile imagefile;

  @override
  void initState() {
    imagefile = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appbar(),
              // Container(
              //   child: IconButton(
              //     icon: const Icon(Icons.info_outline),
              //     onPressed: () {},
              //     alignment: Alignment.topLeft,
              //     color: Colors.black54,
              //   ),
              // ),
            ],
          )),
      backgroundColor: Colors.white,
      body: content(),
    );
  }

  Widget content() {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(
                child: Image.asset(
                  'images/image3.png',
                  width: screenwidth * 0.6,
                  height: screenheight * 0.3,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  'หมายเหตุ : ทางบริษัทจะไม่มีการบันทึกและเก็บรูปภาพจริง จะแสดงเพียงภาพจำลองเท่านั้น',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Card(
                semanticContainer: true,
                elevation: 5,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Colors.white,
                child: Container(
                  width: screenwidth * 0.85,
                  height: screenwidth * 0.25,
                  child: const Center(
                    child: Text(
                      'เบอร์รองเท้าของท่านคือเบอร์ 39\n(EU) (US : 8 , UK : 6)',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 31, 30, 30),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: screenheight * 0.5,
                  height: screenheight * 0.5,
                  child: Image.file(
                    File(imagefile.path),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget appbar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        //  Container(
            // child: IconButton(
            //   icon: const Icon(Icons.arrow_back_ios_outlined),
            //   onPressed: () {},
            //   alignment: Alignment.topLeft,
            //   color: Colors.black54,
            // ),
        //  ),
          Image.asset(
            'images/logo2.png',
            width: 85,
            height: 65,
          ),
          const SizedBox(
            width: 23,
          ),
          Image.asset(
            'images/simply.png',
            width: 85,
            height: 65,
          ),
          const SizedBox(
            width: 23,
          ),
        ],
      );
}
