import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:sizer/sizer.dart';
import 'package:taywin_project/utility/my_style.dart';
import 'package:taywin_project/widget/camera3.dart';

class IntroSliders extends StatefulWidget {
  const IntroSliders(
      {Key? key,
      required this.type,
      required this.screenwidth,
      required this.screenheight})
      : super(
          key: key,
        );
  final String type;
  final double screenwidth;
  final double screenheight;

  @override
  State<IntroSliders> createState() => _IntroSlidersState();
}

class _IntroSlidersState extends State<IntroSliders> {
  List<Slide> slides = [];
  late double screenwidth;
  late double screenheight;

  @override
  void initState() {
    screenwidth = widget.screenwidth;
    screenheight = widget.screenheight;
    super.initState();

    slides.add(
      Slide(
        pathImage: 'images/imagegif.gif',
        widgetTitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            const Text(
              "ขั้นตอนการวัดขนาดเท้า",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ],
        ),
        marginTitle: const EdgeInsets.only(bottom: 15, top: 5),
        widthImage: screenwidth * 0.8,
        heightImage: screenheight * 0.6,
        //foregroundImageFit:BoxFit.cover,
        styleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        widgetDescription: const Text(
          '1.  กรุณาเลือกเพศก่อนทำการวัด\n2. ให้กล้องห่างจากเท้าระยะ 40 ซม. หรือ 16 นิ้ว',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        //  backgroundColor: const Color.fromRGBO(30, 29, 89, 1),
        //   description: 'ให้กล้องห่างจากเท้าในระยะ 40 ซม. หรือ 16 นิ้ว เท่านั้น',
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          // fontStyle: FontStyle.italic,
          // fontFamily: 'Raleway',
        ),
        marginDescription: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: 70.0,
        ),
        centerWidget: const Text(
          "Replace this with a custom widget",
          style: TextStyle(color: Colors.white),
        ),
        onCenterItemPress: () {},
        colorBegin: Colors.orangeAccent,
        colorEnd: const Color.fromRGBO(30, 29, 89, 1),
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      Slide(
        widgetTitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              ),
            ),
            const Text(
              "ขั้นตอนการวัดขนาดเท้า",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoMono',
              ),
            ),
          ],
        ),
        //title: "ขั้นตอนการวัดขนาดเท้า",
        marginTitle: const EdgeInsets.only(bottom: 15, top: 5),
        widthImage: screenwidth * 0.8,
        heightImage: screenheight * 0.55,
        styleTitle: const TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'RobotoMono',
        ),
        pathImage: 'images/imagegif2.gif',
        // foregroundImageFit: BoxFit.cover,
        // marginDescription: EdgeInsets.only(top: 5, bottom: 5),
        widgetDescription: const Text(
          '3. วางปลายส้นเท้าชิดเส้นสีส้มและวางเท้าให้อยู่ในกรอบสีน้ำเงิน\n4. เลื่อนวงกลม ขึ้น-ลง ตามเส้นสีน้ำเงินให้เส้นประ ชิดปลายนิ้วเท้าที่ยาวที่สุด ระบบจะแสดงความยาวของเท้าและเบอร์รองเท้าที่เหมาะสม เมื่อถูกต้องแล้วให้กดถ่ายรูป',
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        marginDescription: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 20.0,
          bottom: 70.0,
        ),
        colorBegin: Colors.lightBlue,
        colorEnd: const Color.fromRGBO(30, 29, 89, 1),
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
  }

  void onDonePress() async {
    if (widget.type == MyStyle().footmeasure) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Camera3(
            type: widget.type,
            screenwidth: widget.screenwidth,
            screenheight: widget.screenheight,
          ),
        ),
      );
    }
  }

  void onSkipPress() async {
    if (widget.type == MyStyle().footmeasure) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Camera3(
            type: widget.type,
            screenwidth: widget.screenwidth,
            screenheight: widget.screenheight,
          ),
        ),
      );
    }
  }

  void onNextPress() {
    log("onNextPress caught");
  }

  Widget renderNextBtn() {
    return const Text(
      'ถัดไป',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget renderPrevBtn() {
    return const Text(
      'ย้อนกลับ',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget renderDoneBtn() {
    return const Text(
      'เสร็จสิ้น',
      style: TextStyle(color: Colors.white),
    );
  }

  Widget renderSkipBtn() {
    return const Text(
      'ข้าม',
      style: TextStyle(color: Colors.white),
    );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(const StadiumBorder()),
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0x33FFA8B0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    //     screenwidth = MediaQuery.of(context).size.width;
    // screenheight = MediaQuery.of(context).size.height;
    return IntroSlider(
      // List slides
      slides: slides,

      // Skip button
      renderSkipBtn: renderSkipBtn(),
      onSkipPress: onSkipPress,
      skipButtonStyle: myButtonStyle(),

      // Next button
      renderNextBtn: renderNextBtn(),
      onNextPress: onNextPress,
      nextButtonStyle: myButtonStyle(),
      // renderPrevBtn: renderPrevBtn(),
      // showPrevBtn: true,
      // nextButtonStyle: myButtonStyle(),

      // Done button
      renderDoneBtn: renderDoneBtn(),
      onDonePress: onDonePress,
      doneButtonStyle: myButtonStyle(),

      // Dot indicator
      colorDot: Colors.white30,
      colorActiveDot: const Color.fromARGB(255, 249, 245, 245),
      sizeDot: 13.0,
    );
  }
}
