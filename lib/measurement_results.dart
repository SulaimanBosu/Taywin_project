// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, prefer_typing_uninitialized_variables, avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:taywin_project/utility/my_style.dart';

class MeasurementResults extends StatefulWidget {
  final XFile image;
  final double width;
  final double height;
  final String type;
  const MeasurementResults({
    Key? key,
    required this.image,
    required this.width,
    required this.height,
    required this.type,
  }) : super(key: key);

  @override
  State<MeasurementResults> createState() => _MeasurementResultsState();
}

class _MeasurementResultsState extends State<MeasurementResults> {
  late XFile imagefile;
  late double screenwidth;
  late double screenheight;
  late double sizewidth;
  late double sizeheight;
  late double sizeTH;
  late double sizeUS;
  late double sizeUK;
  late double waistwidth;
  late double inch;
  bool isType = false;

  final moreControler = TextEditingController();

  void type() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        isType = true;
      });
    } else if (widget.type == MyStyle().waistline) {
      setState(() {
        isType = false;
      });
    }
  }

  void size() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        sizeTH = (15.5 + sizeheight);
        sizeUS = (sizeheight - 18);
        sizeUK = (sizeheight - 19);
      });
    } else if (widget.type == MyStyle().waistline) {
      setState(() {
        waistwidth = sizewidth * 3;
        inch = waistwidth / 2.5;
      });
    } else {
      print('เกิดผิดพลาด');
    }
  }

  @override
  void initState() {
    imagefile = widget.image;
    sizewidth = widget.width;
    sizeheight = widget.height;
    size();
    type();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appbar(),
            ],
          )),
      backgroundColor: Colors.white,
      body: content(),
    );
  }

  Widget content() {
    return isType
        ? SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        Text('${sizewidth.toString()} cm'),
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 60,
                          ),
                          Image.asset(
                            'images/Line5.png',
                            width: screenwidth * 0.4,
                            height: screenheight * 0.01,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/image3.png',
                          width: screenwidth * 0.6,
                          height: screenheight * 0.3,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          child: Image.asset(
                            'images/Line6.png',
                            width: screenwidth * 0.01,
                            //  height: screenheight * 0.8,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text('${sizeheight.toString()} cm')
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        'หมายเหตุ : ทางบริษัทจะไม่มีการบันทึกและเก็บรูปภาพจริง แสดงเพียงภาพจำลองเท่านั้น',
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
                        child: Center(
                          child: Text(
                            'เบอร์รองเท้าของท่านคือเบอร์ ${sizeTH.toStringAsFixed(0)}\n(EU) (US : ${sizeUS.toStringAsFixed(1)} , UK : ${sizeUK.toStringAsFixed(1)})',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontFamily: 'FC-Minimal-Regular',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    more(),
                    groupbutton(),

                    // Center(
                    //   child: Container(
                    //     width: screenheight * 0.5,
                    //     height: screenheight * 0.5,
                    //     child: Image.file(
                    //       File(imagefile.path),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          )
        : SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/belt.png',
                          width: screenwidth * 0.6,
                          height: screenheight * 0.3,
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        'หมายเหตุ : ทางบริษัทจะไม่มีการบันทึกและเก็บรูปภาพจริง แสดงเพียงภาพจำลองเท่านั้น',
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
                        child: Center(
                          child: Text(
                            'ขนาดเอวของท่านสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(0)} นิ้ว',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                                fontFamily: 'FC-Minimal-Regular',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    more(),
                    groupbutton(),

                    // Center(
                    //   child: Container(
                    //     width: screenheight * 0.5,
                    //     height: screenheight * 0.5,
                    //     child: Image.file(
                    //       File(imagefile.path),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget more() {
    return Card(
      // semanticContainer: true,
      elevation: 5,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.white,
      child: TextField(
        cursorColor: Colors.black54,
        controller: moreControler,
        style: const TextStyle(
          fontSize: 18.0,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.more_vert_sharp,
            color: Colors.black54,
          ),
          labelText: 'เพิ่มเติม...',
          labelStyle: TextStyle(color: Colors.black54),
          border: InputBorder.none,
          // enabledBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.black54),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.redAccent),
          // ),
        ),
      ),
    );
  }

  Widget groupbutton() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                  color: Colors.black54,
                )),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                // width: screenwidth * 0.2,
                //color: const Color.fromRGBO(30, 29, 89, 1),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: const Color.fromRGBO(30, 29, 89, 1),
                  ),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text(
                    'ถ่ายใหม่',
                  ),
                ),
              ),
              // const SizedBox(
              //   width: 3,
              // ),
              Container(
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                // width: screenwidth * 0.2,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.save_alt),
                  label: const Text('บันทึก'),
                ),
              ),
            ],
          ),
        ],
      );

  Widget appbar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
