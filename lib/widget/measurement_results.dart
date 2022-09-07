// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, avoid_returning_null_for_void, avoid_print, non_constant_identifier_names, unnecessary_null_comparison, unnecessary_const, unnecessary_string_interpolations
import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';
import 'package:taywin_project/utility/screen_size.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:taywin_project/utility/size.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:screenshot/screenshot.dart';
import 'package:file_picker/file_picker.dart';
import 'package:taywin_project/widget/camera.dart';
import 'package:taywin_project/widget/home.dart';

class MeasurementResults extends StatefulWidget {
  final XFile image;
  final double width;
  final double height;
  final String type;
  final bool isMan;
  const MeasurementResults({
    Key? key,
    required this.image,
    required this.width,
    required this.height,
    required this.type,
    required this.isMan,
  }) : super(key: key);

  @override
  State<MeasurementResults> createState() => _MeasurementResultsState();
}

class _MeasurementResultsState extends State<MeasurementResults> {
  File? imagefile;
  late double screenwidth;
  late double screenheight;
  late double sizewidth;
  late double sizeheight;
  late String sizeTH;
  late String sizeUS;
  late String sizeUK;
  late double waistwidth;
  late double inch;
  late List<String> sizes = [];
  bool isType = false;
  bool isMan = false;
  String device = '';
  bool onLoading = false;
  bool isNosave = true;
  ScreenshotController screenshotController = ScreenshotController();
  static const MethodChannel _channel =
      const MethodChannel('image_gallery_saver');

  final moreControler = TextEditingController();
  bool isUpload = true;

  void type() {
    if (widget.type == MyStyle().footmeasure) {
      setState(() {
        isType = true;
        isMan = widget.isMan;
      });
    } else if (widget.type == MyStyle().waistline) {
      setState(() {
        isType = false;
      });
    }
  }

  void size() {
    if (isType) {
      if (isMan) {
        setState(() {
          sizes = Sizes().man(sizeheight);
          sizeTH = sizes[0];
          sizeUS = sizes[1];
          sizeUK = sizes[2];
        });
      } else {
        setState(() {
          sizes = Sizes().woman(sizeheight);
          sizeTH = sizes[0];
          sizeUS = sizes[1];
          sizeUK = sizes[2];
        });
      }
    } else if (!isType) {
      setState(() {
        waistwidth = sizewidth;
        inch = waistwidth / 2.54;
      });
    } else {
      //  print('เกิดผิดพลาด');
    }
  }

  @override
  void initState() {
    getPermissionStatus();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // imagefile = widget.image;
    sizewidth = widget.width;
    sizeheight = widget.height;
    type();
    size();
    super.initState();
  }

  getPermissionStatus() async {
    await Permission.storage.request();
    var status_storage = await Permission.storage.status;
    if (status_storage.isGranted) {
      debugPrint('Camera Permission: GRANTED');
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          onLoading = true;
        });
      });
    } else {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          onLoading = true;
        });
      });
      debugPrint('Camera Permission: DENIED');
    }
  }

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    device = ScreenSize().screenwidth(screenwidth);
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black54),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (isNosave) {
                          _showAlertDialog(
                              Icons.access_alarm_outlined,
                              context,
                              'กลับสู่หน้าแรก',
                              'ท่านต้องการกลับสู่หน้าแรกและละทิ้งข้อมูลการวัดขนาดครั้งนี้ใช่หรือไม่',
                              false);
                        } else {
                          Navigator.pushAndRemoveUntil(
                              context,
                              (MaterialPageRoute(
                                builder: (context) => const MyHome(),
                              )),
                              (route) => false);
                        }
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_outlined)),
                  appbar(),
                ],
              )),
          backgroundColor: Colors.white,
          body: Container(
            color: Colors.white,
            child: onLoading ? content() : MyStyle().progress(context),
          ),
        ),
      ),
    );
  }

  Widget content() {
    return isType
        ? SafeArea(
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     const SizedBox(
                          //       width: 60,
                          //     ),
                          //     Text('${sizewidth.toStringAsFixed(1)} ซม.'),
                          //   ],
                          // ),
                          // Container(
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       const SizedBox(
                          //         width: 60,
                          //       ),
                          //       Image.asset(
                          //         'images/arrow2.png',
                          //         width: screenwidth * 0.35,
                          //         height: screenheight * 0.06,
                          //       ),
                          //     ],
                          //   ),
                          // ),
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
                              Image.asset(
                                'images/arrow.png',
                                width: screenwidth * 0.015,
                                height: screenheight * 0.28,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text('${sizeheight.toStringAsFixed(1)} ซม.')
                            ],
                          ),

                          const SizedBox(
                            height: 15,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 30, right: 30),
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
                          // typeButton2(),
                          typeButton(),
                          const SizedBox(
                            height: 5,
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
                              height: screenwidth * 0.28,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'เบอร์รองเท้าของท่านคือเบอร์ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54,
                                          fontFamily: 'FC-Minimal-Regular',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        showdialog(
                                            context,
                                            isMan
                                                ? 'ตารางเทียบไซส์รองเท้าสุภาพบุรุษ'
                                                : 'ตารางเทียบไซส์รองเท้าสุภาพสตรี',
                                            isMan
                                                ? 'images/mansize.jpg'
                                                : 'images/womansize.jpg');
                                      },
                                      child: const Text(
                                        'ดูตารางไซส์รองเท้า',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 16,
                                            color: Colors.lightBlue,
                                            fontFamily: 'FC-Minimal-Regular',
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          more(),
                        ],
                      ),
                    ),
                    groupbutton(),
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
                    Container(
                        color: Colors.white,
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
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: screenwidth * 0.15),
                                  child:
                                      Text('${inch.toStringAsFixed(1)} นิ้ว'),
                                ),
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/Line1.png',
                                    width: screenwidth * 0.8,
                                    height: screenheight * 0.01,
                                  ),
                                ],
                              ),
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
                                child: Center(
                                  child: Text(
                                    widget.isMan
                                        ? 'ขนาดรอบเอวของท่านสุภาพบุรุษสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(1)} นิ้ว'
                                        : 'ขนาดรอบเอวของท่านสุภาพสตรีสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(1)} นิ้ว',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black54,
                                        fontFamily: 'FC-Minimal-Regular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            more(),

                            // Center(
                            //   child: Container(
                            //     width: screenheight * 0.5,
                            //     height: screenheight * 0.5,
                            //     child: imagefile != null
                            //         ? Image.file(
                            //             File(imagefile.path),
                            //           )
                            //         : Container(),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                  
                    groupbutton(),
                  ],
                ),
              ),
            ),
          );
  }

  showdialog(BuildContext context, String type, String image) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //insetPadding: const EdgeInsets.only(left: 2, right: 2,top: 10,bottom: 10),
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.close),
                // ),

                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.black45,
                    fontFamily: 'FC-Minimal-Regular',
                  ),
                ),

                const Divider(
                  thickness: 1,
                  height: 5,
                  color: Colors.black54,
                )
              ],
            ),
          ),
          contentPadding:
              EdgeInsets.only(left: 2, right: 2, top: 0.1.h.h, bottom: 5.h),
          content: isMan
              ? Image.asset(image)
              : Image.asset(
                  image,
                  // fit: BoxFit.cover,
                  width: 100.w,
                  height: 42.h,
                ),
          actions: [
            InkWell(
              onTap: (() => Navigator.of(context).pop()),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 15.w,
                    height: 3.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text('ปิด'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }

  Row typeButton2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isMan = false;
              size();
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: screenwidth * 0.35,
                height: screenwidth * 0.12,
                color: isMan
                    ? Colors.grey.withOpacity(0.3)
                    : MyStyle().primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        const AssetImage('images/woman.png'),
                        size: 25,
                        color: isMan
                            ? const Color.fromARGB(137, 82, 78, 78)
                            : Colors.white,
                      ),
                      Text(
                        'ไซส์รองเท้าสตรี',
                        style: TextStyle(
                          fontFamily: 'FC-Minimal-Regular',
                          fontSize: 18,
                          color: isMan
                              ? const Color.fromARGB(137, 82, 78, 78)
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isMan = true;
              size();
            });
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: screenwidth * 0.35,
                height: screenwidth * 0.12,
                color: isMan
                    ? MyStyle().primaryColor
                    : Colors.grey.withOpacity(0.3),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      const AssetImage('images/man.png'),
                      size: 25,
                      color: isMan
                          ? Colors.white
                          : const Color.fromARGB(137, 82, 78, 78),
                    ),
                    Text(
                      'ไซส์รองเท้าบุรุษ',
                      style: TextStyle(
                        fontFamily: 'FC-Minimal-Regular',
                        fontSize: 18,
                        color: isMan
                            ? Colors.white
                            : const Color.fromARGB(137, 82, 78, 78),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget typeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isMan = false;
              size();
            });
          },
          child: Container(
            width: screenwidth * 0.35,
            height: screenheight * 0.09,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('images/woman.png'),
                    size: !isMan ? 30 : 25,
                    color: isMan
                        ? const Color.fromARGB(137, 82, 78, 78)
                        : MyStyle().primaryColor,
                  ),
                  Text(
                    'ไซส์รองเท้าสตรี',
                    style: TextStyle(
                      fontFamily: 'FC-Minimal-Regular',
                      fontSize: !isMan ? 16 : 14,
                      color: !isMan
                          ? MyStyle().primaryColor
                          : const Color.fromARGB(137, 82, 78, 78),
                    ),
                  ),
                  Divider(
                    endIndent: 30,
                    indent: 30,
                    thickness: 2,
                    height: 5,
                    color: isMan ? Colors.white : MyStyle().primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isMan = true;
              size();
            });
          },
          child: Container(
            width: screenwidth * 0.35,
            height: screenheight * 0.09,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('images/man.png'),
                    size: isMan ? 30 : 25,
                    color: isMan
                        ? MyStyle().primaryColor
                        : const Color.fromARGB(137, 82, 78, 78),
                  ),
                  Text(
                    'ไซส์รองเท้าบุรุษ',
                    style: TextStyle(
                      fontFamily: 'FC-Minimal-Regular',
                      fontSize: isMan ? 16 : 14,
                      color: isMan
                          ? MyStyle().primaryColor
                          : const Color.fromARGB(137, 82, 78, 78),
                    ),
                  ),
                  Divider(
                    endIndent: 30,
                    indent: 30,
                    thickness: 2,
                    height: 5,
                    color: isMan ? MyStyle().primaryColor : Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget more() {
    return Container(
      width: screenwidth * 0.87,
      child: Card(
        // semanticContainer: true,
        elevation: 5,
        // margin: const EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: TextField(
          keyboardType: TextInputType.text,
          maxLines: 10,
          minLines: 1,
          maxLength: 300,
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
            labelText: 'แสดงความคิดเห็นเพิ่มเติม...',
            labelStyle: TextStyle(color: Colors.black54),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget groupbutton() => Container(
        padding: const EdgeInsets.only(bottom: 30, top: 10),
        width: screenwidth * 0.85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              child: IconButton(
                  onPressed: () {
                    shareScreenshot();
                    print('moreControler ====== ${moreControler.text}');
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black54,
                  )),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (isNosave) {
                        _showAlertDialog(
                            Icons.access_alarm_outlined,
                            context,
                            'ยืนยันถ่ายใหม่',
                            'ท่านต้องการละทิ้งข้อมูลการวัดขนาดครั้งนี้ใช่หรือไม่',
                            true);
                      } else {
                        if (isType) {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Camera3(
                                type: MyStyle().footmeasure,
                                screenwidth: screenwidth,
                                screenheight: screenheight,
                              ),
                            ),
                          );
                        } else {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Camera3(
                                type: MyStyle().waistline,
                                screenwidth: screenwidth,
                                screenheight: screenheight,
                              ),
                            ),
                          );
                        }
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      }
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
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      screenshotAndSave();
                      setState(() {
                        isUpload = false;
                      });
                    },
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
        ),
      );

  Future<void> share() async {
    await FlutterShare.share(
      title: isType ? 'ไซส์รองเท้า : ' : 'ขนาดรอบเอว : ',
      text: isType
          ? isMan
              ? moreControler.text != ''
                  ? 'เบอร์รองเท้าของท่านสุภาพบุรุษคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )\n ความคิดเห็นเพิ่มเติม : ${moreControler.text}'
                  : 'เบอร์รองเท้าของท่านสุภาพบุรุษคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )'
              : moreControler.text != ''
                  ? 'เบอร์รองเท้าของท่านสุภาพสตรีคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )\n ความคิดเห็นเพิ่มเติม : ${moreControler.text}'
                  : 'เบอร์รองเท้าของท่านสุภาพสตรีคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )'
          : moreControler.text != ''
              ? 'ขนาดรอบเอวของท่านสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(0)} นิ้ว\n ความคิดเห็นเพิ่มเติม : ${moreControler.text}'
              : 'ขนาดรอบเอวของท่านสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(0)} นิ้ว',
      chooserTitle: 'การแชร์',
    );
  }

  void screenshotAndSave() {
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((capturedImage) async {
      final String localPath = '${DateTime.now().toIso8601String()}';
      final result = await saveImage(
        Uint8List.fromList(capturedImage!),
        quality: 60,
        name: localPath,
      );

      if (result == false) {
        isUpload = true;
        setState(() {
          MyStyle().showdialog(Icons.save_alt_outlined, context, 'ล้มเหลว!',
              'กรุณาอณุญาตให้แอพสามารถเข้าถึงรูปภาพได้ จึงจะสามารถบันทึกได้สำเร็จ');
        });
      } else {
        setState(() {
          isNosave = false;
          isUpload = true;
          MyStyle().showdialog(Icons.save_alt_outlined, context, 'บันทึก',
              'บันทึกไปยังคลังรูปภาพเรียบร้อย');
        });
      }
      // ShowCapturedWidget(context, capturedImage);
    }).catchError((onError) {
      print(onError);
    });
  }

  // Future<dynamic> ShowCapturedWidget(
  //     BuildContext context, Uint8List capturedImage) {
  //   return showDialog(
  //     useSafeArea: false,
  //     context: context,
  //     builder: (context) => Scaffold(
  //       appBar: AppBar(
  //         title: Text("Captured widget screenshot"),
  //       ),
  //       body: Center(
  //         child: capturedImage != null
  //             ? Image.memory(capturedImage)
  //             : Container(
  //                 width: 200,
  //                 height: 200,
  //                 color: Colors.blue,
  //               ),
  //       ),
  //     ),
  //   );
  // }

  Future<void> shareScreenshot() async {
    screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((capturedImage) async {
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
      Uint8List imageInUnit8List = capturedImage!;
      File file = await File(
              '${directory!.path}/${DateTime.now().toIso8601String()}.jpg')
          .create();
      file.writeAsBytesSync(imageInUnit8List);
      print('path ========>>> ${file.path.toString()}');

      //await Future.delayed(const Duration(milliseconds: 10));
      await FlutterShare.shareFile(
        title: isType ? 'ไซส์รองเท้า : ' : 'ขนาดรอบเอว : ',
        text: isType
            ? isMan
                ? moreControler.text != ''
                    ? 'เบอร์รองเท้าของท่านสุภาพบุรุษคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )\n ความคิดเห็นเพิ่มเติม : ${moreControler.text}'
                    : 'เบอร์รองเท้าของท่านสุภาพบุรุษคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )'
                : moreControler.text != ''
                    ? 'เบอร์รองเท้าของท่านสุภาพสตรีคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )\n ความคิดเห็นเพิ่มเติม : ${moreControler.text}'
                    : 'เบอร์รองเท้าของท่านสุภาพสตรีคือ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )'
            : moreControler.text != ''
                ? 'ขนาดรอบเอวของท่านสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(0)} นิ้ว\n ความคิดเห็นเพิ่มเติม : ${moreControler.text}'
                : 'ขนาดรอบเอวของท่านสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(0)} นิ้ว',
        chooserTitle: 'แชร์',
        filePath: file.path,
        fileType: 'image/jpg',
      );
      print('path ========>>> ${file.path}');
    }).catchError((onError) {
      print(onError);
    });
  }

  static FutureOr<dynamic> saveImage(Uint8List imageBytes,
      {int quality = 80,
      String? name,
      bool isReturnImagePathOfIOS = false}) async {
    assert(imageBytes != null);
    final result =
        await _channel.invokeMethod('saveImageToGallery', <String, dynamic>{
      'imageBytes': imageBytes,
      'quality': quality,
      'name': name,
      'isReturnImagePathOfIOS': isReturnImagePathOfIOS
    }).then(
      (value) {
        print('object ========= $value');
        return value['isSuccess'];
      },
    );
    return result;
  }

  void _showAlertDialog(IconData icon, BuildContext context, String textTitle,
      String textContent, bool pageRoute) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                Icon(icon),
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
              thickness: 0,
              height: 5,
              color: Colors.black38,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
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
              onPressed: () async {
                Navigator.pop(context);
                isNosave = true;
                if (pageRoute) {
                  if (isType) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Camera3(
                          type: MyStyle().footmeasure,
                          screenwidth: screenwidth,
                          screenheight: screenheight,
                        ),
                      ),
                    );
                  } else {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Camera3(
                          type: MyStyle().waistline,
                          screenwidth: screenwidth,
                          screenheight: screenheight,
                        ),
                      ),
                    );
                  }
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                  ]);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      (MaterialPageRoute(
                        builder: (context) => const MyHome(),
                      )),
                      (route) => false);
                }
              },
              child: const Text(
                'ใช่',
                style: TextStyle(color: Colors.blue),
              )),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'ไม่',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    bool onTab = false;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          children: [
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Icon(Icons.exit_to_app_outlined),
                const SizedBox(
                  width: 5,
                ),
                const Text(
                  'ออก',
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
              thickness: 0,
              height: 5,
              color: Colors.black38,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
        content: const Text(
          'ท่านต้องการออกจากแอพใช่หรือไม่',
          style: TextStyle(
            overflow: TextOverflow.clip,
            fontSize: 20.0,
            color: Colors.black45,
            fontFamily: 'FC-Minimal-Regular',
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
              onPressed: () async {
                Navigator.pop(context);
                setState(() {
                  onTab = true;
                  if (onTab) {
                    if (Platform.isAndroid) {
                      SystemNavigator.pop();
                    } else if (Platform.isIOS) {
                      exit(0);
                    }
                  }
                });
              },
              child: const Text(
                'ใช่',
                style: TextStyle(color: Colors.blue),
              )),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'ไม่',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );

    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: const Text('Are you sure?'),
    //     content: const Text('Do you want to exit an App'),
    //     actions: <Widget>[
    //       GestureDetector(
    //         onTap: () {
    //           Navigator.of(context).pop();
    //           setState(() {
    //             onTab = false;
    //           });
    //         },
    //         child: const Text("NO"),
    //       ),
    //       const SizedBox(height: 16),
    //       GestureDetector(
    //         onTap: () {
    //           // Navigator.of(context).pop(true);

    //         },
    //         child: const Text("YES"),
    //       ),
    //     ],
    //   ),
    // );
    return onTab;
  }

  Widget progress(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
        content(),
        Container(
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
            color: Colors.white70,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.3,
            alignment: AlignmentDirectional.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: const CupertinoActivityIndicator(
                      radius: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: const Center(
                    child: Text(
                      'กำลังบันทึก...',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        fontFamily: 'FC-Minimal-Regular',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget appbar() => Row(
        mainAxisAlignment: MainAxisAlignment.start,
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
          SizedBox(
            width: (screenwidth * 20) / 100,
          ),
        ],
      );
}
