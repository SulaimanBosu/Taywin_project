// ignore_for_file: sized_box_for_whitespace, unnecessary_string_interpolations, avoid_unnecessary_containers, unused_element

import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = const Color.fromRGBO(30, 29, 89, 1);
  Color redColor = Colors.red;
  Color appbarColor = Colors.red;
  String detail1 =
      '1. หลังจากกดเปิดกล้องแล้วให้ลูกค้าเลือกเพศก่อนทำการวัด\n2. ให้กล้องห่างจากเท้าระยะ 40 ซ.ม. หรือ 16 นิ้ว\n3. วางปลายส้นเท้าชิดเส้นสีส้มและวางเท้าให้อยู่ในกรอบสีน้ำเงิน\n4. เลื่อนวงกลม ขึ้น-ลง ตามเส้นสีน้ำเงินให้เส้นประ ชิดปลายนิ้วเท้าที่ยาวที่สุด ระบบจะแสดงความยาวของเท้าและเบอร์รองเท้าที่เหมาะสมของลูกค้า เมื่อถูกต้องแล้วให้กดถ่ายรูป';
  String detail2 =
      '1. ห้ามใส่เสื้อคลุมหรือใส่ชุดที่จะทำให้การวัดขนาดของเอวท่านไม่ตรงกับความเป็นจริง\n2. ให้ขยับกล้องขึ้นลงเพื่อให้แกนสีแดงและสีส้มตรงกับตำแหน่งของการใส่เข็มขัดจริงของท่าน ระบบจะแสดงขนาดรอบเอวขั้นต้นออกมา(เพื่อป้องกันข้อมูลคลาดเคลื่อน กรุณาให้เส้นแดงและเหลืองอยู่ในระดับที่ใส่เข็มขัดจริงเท่านั้น)\n3. ท่านสามารถใช้นิ้วกดค้างที่เส้นสีเขียวเพื่อเลื่อนตำแหน่งเข้า-ออก เพื่อให้แสดงข้อมูลของการวัดที่ถูกต้องที่สุด เมื่อถูกต้องให้กดถ่าย';
 // String detail2 =
  //    '1. ห้ามใส่เสื้อคลุมหรือใส่ชุดที่จะทำให้การวัดขนาดของเอวท่านไม่ตรงกับความเป็นจริง\n2. ให้กล้องห่างจากเอวในระยะ 40 ซม. หรือ 15 นิ้ว เท่านั้น\n3. ให้ขยับกล้องขึ้นลงเพื่อให้แกนสีแดงและสีส้มตรงกับตำแหน่งของการใส่เข็มขัดจริงของคุณลูกค้า ระบบจะแสดงขนาดรอบเอวขั้นต้นออกมา(เพื่อป้องกันข้อมูลคลาดเคลื่อน กรุณาให้เส้นแดงและเหลืองอยู่ในระดับที่ใส่เข็มขัดจริงเท่านั้น)\n4. ลูกค้าสามารถใช้นิ้วกดค้างที่เส้นสีเขียวเพื่อเลื่อนตำแหน่งเข้า-ออก เพื่อให้แสดงข้อมูลของการวัดที่ถูกต้องที่สุด เมื่อถูกต้องให้กดถ่าย';
  String imageWaistline = 'images/image2.png';
  String imageFootmeasure = 'images/image.jpg';
  String waistline = 'waistline';
  String footmeasure = 'footmeasure';

  Text textdetail(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  Text text(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  Widget showProgress(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            text,
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w700,
                fontSize: 15),
          ),
        ],
      ),
    );
  }

  TextStyle textStyle = const TextStyle(
    fontSize: 18.0,
    // fontWeight: FontWeight.bold,
    color: Colors.white,
    // fontStyle: FontStyle.italic,
    fontFamily: 'FC-Minimal-Regular',
  );

  Text showtext_1(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          // fontWeight: FontWeight.bold,
          color: Colors.black45,
          // fontStyle: FontStyle.italic,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  Text showtext_2(String title) => Text(
        title,
        style: textStyle,
      );

  Text showTitle_2(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 24.0,
          // fontWeight: FontWeight.bold,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  SizedBox mySizebox() => const SizedBox(
        width: 8.0,
        height: 16.0,
      );

  Widget titleCenter(BuildContext context, String string) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Text(
          string,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Text showTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 32.0,
          // fontWeight: FontWeight.bold,
          color: Colors.black54,
          // fontStyle: FontStyle.italic,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  showBasicsFlash({
    BuildContext? context,
    String? text,
    Duration? duration,
    flashStyle = FlashBehavior.floating,
  }) {
    showFlash(
      context: context!,
      duration: duration,
      builder: (context, controller) {
        return Flash(
          controller: controller,
          behavior: flashStyle,
          position: FlashPosition.top,
          boxShadows: kElevationToShadow[4],
          horizontalDismissDirection: HorizontalDismissDirection.horizontal,
          child: FlashBar(
            content: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.redAccent,
                ),
                MyStyle().mySizebox(),
                Text(text!),
              ],
            ),
          ),
        );
      },
    );
  }

  confirmDialog2(
    BuildContext context,
    String imageUrl,
    String textTitle,
    String textContent,
    Widget prossedYes,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Image.network(
              '$imageUrl',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            Text(textTitle)
          ]),
          content: Text(textContent),
          actions: <Widget>[
            // ignore: deprecated_member_use
            OutlinedButton(
              child: const Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).pop();
                // ใส่เงื่อนไขการกดตกลง
                MaterialPageRoute route =
                    MaterialPageRoute(builder: (value) => prossedYes);
                Navigator.pushAndRemoveUntil(context, route, (route) => false);
              },
            ),
            // ignore: deprecated_member_use
            OutlinedButton(
              child: const Text("ยกเลิก"),
              onPressed: () {
                // ใส่เงื่อนไขการกดยกเลิก

                Navigator.of(context).pop();
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        );
      },
    );
  }

  showdialog(
    IconData icon,
    BuildContext context,
    String textTitle,
    String textContent,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.black45,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    textTitle,
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.black45,
                      fontFamily: 'FC-Minimal-Regular',
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 1,
                height: 5,
                color: Colors.black54,
              )
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
          actions: <Widget>[
            // ignore: deprecated_member_use
            OutlinedButton(
              child: const Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // ignore: deprecated_member_use
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      },
    );
  }

  Image showlogo(double screenwidth) {
    return Image.asset(
      'images/logo.png',
      width: screenwidth * 0.6,
      height: screenwidth * 0.6,
    );
  }

  // BoxDecoration myBoxDecoration(String namePic) {
  //   return BoxDecoration(
  //     image: DecorationImage(
  //         image: AssetImage('images/$namePic'), fit: BoxFit.cover),
  //   );
  // }

  Widget progress(BuildContext context) {
    return Container(
        child: Stack(
      children: <Widget>[
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
                  margin: const EdgeInsets.only(top: 25.0),
                  child: const Center(
                    child: Text(
                      'ดาวน์โหลด...',
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

  MyStyle();
}
