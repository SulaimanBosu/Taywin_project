// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace, avoid_returning_null_for_void, avoid_print, non_constant_identifier_names, unnecessary_null_comparison
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
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
  bool isMen = false;
  String device = '';
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? _imageFile;
  final int _counter = 0;

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
    if (isType) {
      if (isMen) {
        setState(() {
          sizes = Size().man(sizeheight);
          sizeTH = sizes[0];
          sizeUS = sizes[1];
          sizeUK = sizes[2];
        });
      } else {
        setState(() {
          sizes = Size().woman(sizeheight);
          sizeTH = sizes[0];
          sizeUS = sizes[1];
          sizeUK = sizes[2];
        });
      }
    } else if (!isType) {
      setState(() {
        waistwidth = sizewidth;
        inch = waistwidth / 2.5;
      });
    } else {
      //  print('เกิดผิดพลาด');
    }
  }

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
    device = ScreenSize().screenwidth(screenwidth);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black54),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        (MaterialPageRoute(
                          builder: (context) => const MyHome(),
                        )),
                        (route) => false);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_outlined)),
              appbar(),
            ],
          )),
      backgroundColor: Colors.white,
      body: Screenshot(
        
        controller: screenshotController,
        child: Container(color: Colors.white, child: content()),
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
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 60,
                        ),
                        Text('${sizewidth.toStringAsFixed(1)} ซม.'),
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
                            'images/Line1.png',
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
                            'images/Line2.png',
                            width: screenwidth * 0.01,
                            //  height: screenheight * 0.8,
                          ),
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
                        height: screenwidth * 0.25,
                        child: Center(
                          child: Text(
                            'เบอร์รองเท้าของท่านคือเบอร์ ${sizeTH.toString()} (EU) \n( US : ${sizeUS.toString()} , UK : ${sizeUK.toString()} )',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                                fontFamily: 'FC-Minimal-Regular',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      color: Colors.red,
                      width: 200,
                      height: 200,
                      child: Center(
                        child: _imageFile != null
                            ? Image.memory(_imageFile!)
                            : Container(
                                width: 200,
                                height: 200,
                                color: Colors.blue,
                              ),
                      ),
                    ),
                    // Container(
                    //   color: Colors.green,
                    //   width: 200,
                    //   height: 200,
                    //   child: Center(
                    //     child: _imageFile != null
                    //         ? Image.memory(_imageFile!)
                    //         : Container(),
                    //   ),
                    // ),
                    more(),
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
                          padding: EdgeInsets.only(right: screenwidth * 0.15),
                          child: Text('${inch.toStringAsFixed(0)} นิ้ว'),
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
                            'ขนาดรอบเอวของท่านสำหรับใส่เข็มขัด คือ \n${waistwidth.toStringAsFixed(0)} ซม. หรือ ${inch.toStringAsFixed(0)} นิ้ว',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
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
            ),
          );
  }

  Row typeButton2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isMen = false;
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
                color: isMen
                    ? Colors.grey.withOpacity(0.3)
                    : MyStyle().primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        const AssetImage('images/woman.png'),
                        size: 25,
                        color: isMen
                            ? const Color.fromARGB(137, 82, 78, 78)
                            : Colors.white,
                      ),
                      Text(
                        'ไซส์รองเท้าสตรี',
                        style: TextStyle(
                          fontFamily: 'FC-Minimal-Regular',
                          fontSize: 18,
                          color: isMen
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
              isMen = true;
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
                color: isMen
                    ? MyStyle().primaryColor
                    : Colors.grey.withOpacity(0.3),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ImageIcon(
                      const AssetImage('images/man.png'),
                      size: 25,
                      color: isMen
                          ? Colors.white
                          : const Color.fromARGB(137, 82, 78, 78),
                    ),
                    Text(
                      'ไซส์รองเท้าบุรุษ',
                      style: TextStyle(
                        fontFamily: 'FC-Minimal-Regular',
                        fontSize: 18,
                        color: isMen
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
              isMen = false;
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
                    size: !isMen ? 30 : 25,
                    color: isMen
                        ? const Color.fromARGB(137, 82, 78, 78)
                        : MyStyle().primaryColor,
                  ),
                  Text(
                    'ไซส์รองเท้าสตรี',
                    style: TextStyle(
                      fontFamily: 'FC-Minimal-Regular',
                      fontSize: !isMen ? 16 : 14,
                      color: !isMen
                          ? MyStyle().primaryColor
                          : const Color.fromARGB(137, 82, 78, 78),
                    ),
                  ),
                  Divider(
                    endIndent: 30,
                    indent: 30,
                    thickness: 2,
                    height: 5,
                    color: isMen ? Colors.white : MyStyle().primaryColor,
                  )
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isMen = true;
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
                    size: isMen ? 30 : 25,
                    color: isMen
                        ? MyStyle().primaryColor
                        : const Color.fromARGB(137, 82, 78, 78),
                  ),
                  Text(
                    'ไซส์รองเท้าบุรุษ',
                    style: TextStyle(
                      fontFamily: 'FC-Minimal-Regular',
                      fontSize: isMen ? 16 : 14,
                      color: isMen
                          ? MyStyle().primaryColor
                          : const Color.fromARGB(137, 82, 78, 78),
                    ),
                  ),
                  Divider(
                    endIndent: 30,
                    indent: 30,
                    thickness: 2,
                    height: 5,
                    color: isMen ? MyStyle().primaryColor : Colors.white,
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
        width: screenwidth * 0.85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: IconButton(
                  onPressed: () {
                    share();
                    //   shareFile();
                    // shareScreenshot();
                    // screenshot();
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
                      try {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OpenCamera(
                              type: isType
                                  ? MyStyle().footmeasure
                                  : MyStyle().waistline,
                            ),
                          ),
                        );
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                        ]);
                      } catch (e) {
                        print(e);
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
                      screenshot();
                      shareScreenshot();
                     // shareFile();
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
          ? isMen
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

  void screenshot() {
    screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((capturedImage) async {
      setState(() {
        _imageFile = capturedImage;
      });

      // ShowCapturedWidget(context, capturedImage!);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text("Captured widget screenshot"),
        ),
        body: Center(
          child: capturedImage != null
              ? Image.memory(capturedImage)
              : Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue,
                ),
        ),
      ),
    );
  }

  Future<void> shareFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null || result.files.isEmpty) return null;

    await FlutterShare.shareFile(
      title: 'Example share',
      text: 'Example share text',
      filePath: result.files[0] as String,
    );
  }

  Future<void> shareScreenshot() async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final String localPath =
        '${directory!.path}/${DateTime.now().toIso8601String()}.png';

    await screenshotController.captureAndSave(localPath);


    await FlutterShare.shareFile(
        title: 'Compartilhar comprovante',
        filePath: localPath,
        fileType: 'image/png');
     print('path ========>>>   $localPath');
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
