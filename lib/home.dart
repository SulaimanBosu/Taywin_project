// ignore_for_file: avoid_unnecessary_containers, deprecated_member_use
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:taywin_project/camere.dart';

class MyHome extends StatefulWidget {
  const MyHome({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(30, 29, 89, 1),
      // body: Center(
      //     child: Text(screenwidth.toString(),
      //         style: const TextStyle(color: Colors.white))),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/logo.png',
                    width: screenwidth * 0.6,
                    height: screenwidth * 0.6,
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      dialog('images/image.jpg',
                          '1. ให้กล้องห่างจากเท้าในระยะ 30 CM หรือ 12 นิ้ว เท่านั้น\n2. ให้ปลายส้นเท้าซ้ายหรือขวา(เพียงด้านเดียว) และด้านข้างของเท้าอยู่ชิดติดเส้นสีแดงทั้งแนวตั้งและแนวนอน\n3. เลื่อนเส้นที่เหลืองชิดขอบอีกด้านของเท้าลูกค้า เพื่อวัดความกว้างของเท้า\n4. ระบบจะแสดงเส้นสีเขียวอัตโนมัติ พร้อมแสดงไซส์ขนาดรองเท้าของเท้าโดยเพื่อความสบายในการใส่ ลูกค้าสามารถกดค้างเส้นสีเขียว เลื่อนไปมาเพื่อเลือกไซส์ที่ท่านต้องการ เมื่อถูกต้องให้กดถ่าย');
                    },
                    label: const Text(
                      'วัดขนาดเท้า',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FloatingActionButton.extended(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      dialog('images/image2.jpg',
                          '1. ห้ามใส่เสื้อคลุมหรือใส่ชุดที่จะทำให้การวัดขนาดของเอวท่านไม่ตรงกับความเป็นจริง\n2. ให้กล้องห่างจากเอวในระยะ 30 CM หรือ 12 นิ้ว เท่านั้น\n3. ให้ขยับกล้องขึ้นลงเพื่อให้แกนสีแดงสีส้มตรงกับตำแหน่งของการใส่เข็มขัดจริงของคุณลูกค้า ระบบจะแสดงรอบเอวขั้นต้นออกมาอัตโนมัติ(เพื่อป้องกันข้อมูลคลาดเคลื่อน กรุณาให้เส้นแดงและเหลืองอยู่ในระดับที่ใส่เข็มขัดจริงเท่านั้น)\n4. ลูกค้าสามารถใช้นิ้วกดค้างที่เส้นสีเขียวเพื่อเลื่อนตำแหน่งเข้า-ออก เพื่อให้แสดงข้อมูลของการวัดที่ถูกต้องที่สุด เมื่อถูกต้องให้กดถ่าย');
                      // _showPicker(context);
                    },
                    label: const Text(
                      'วัดขนาดรอบเอว',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
        ],
      ),
    );
  }

  Future<void> dialog(String image, String message) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => SimpleDialog(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
              //     width: 200,height: 180,
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.5,
              child: Container(
                child: Image.asset(image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'ข้อควรปฎิบัติเพื่อการวัดที่ถูกต้อง',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton.icon(
                  onPressed: () async {
                    try {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OpenCamera(
                            cameras: widget.camera,
                          ),
                        ),
                      );
                    } catch (e) {
                      // ignore: avoid_print
                      print(e);
                    }

                    // MaterialPageRoute route = MaterialPageRoute(
                    //   builder: (context) => const OpenCamera(
                    //     camera: widget.camera;
                    //   ),
                    // );
                    // Navigator.pushAndRemoveUntil(
                    //     context, route, (route) => true);
                    // Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.photo_camera,
                    color: Colors.red,
                  ),
                  label: const Text('เปิดกล้อง'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.green,
                  ),
                  label: const Text('ยกเลิก'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ],
            )
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    );
  }
}
