// ignore_for_file: sized_box_for_whitespace, unnecessary_string_interpolations, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Colors.blue.shade900;
  Color primaryColor = Colors.green.shade400;
  Color redColor = Colors.red;
  Color appbarColor = Colors.red;


    Text textdetail_1(String title) => Text(
        title,
        // ignore: prefer_const_constructors
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

          Text text1(String title) => Text(
        title,
        // ignore: prefer_const_constructors
        style: TextStyle(
          fontSize: 16.0,
          color:Colors.black45,
          fontFamily: 'FC-Minimal-Regular',
        ),
      );

  Widget showProgress() {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      ),
    );
  }

  Widget showProgress2(String text) {
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

  TextStyle mainTitle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.black54,
  );

  TextStyle mainH2Title = const TextStyle(
    fontSize: 14.0,
    // fontWeight: FontWeight.bold,
    color: Colors.black45,
    // fontStyle: FontStyle.italic,
    fontFamily: 'FC-Minimal-Regular',
  );

    TextStyle text2 = const TextStyle(
    fontSize: 18.0,
    // fontWeight: FontWeight.bold,
    color: Colors.black45,
    // fontStyle: FontStyle.italic,
    fontFamily: 'FC-Minimal-Regular',
  );
      Text showtext_1(String title) => Text(
        title,
        style: mainH2Title,
      );

    Text showtext_2(String title) => Text(
        title,
        style: text2,
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

  Text showText(String title) => Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontStyle: FontStyle.italic,
        ),
      );

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

  Text showTitleH2(String title) => Text(
        title,
        style: const TextStyle(
                  fontSize: 24.0,
                 // fontWeight: FontWeight.bold,
                  color: Colors.black45,
                  fontFamily: 'FC-Minimal-Regular',
                ),
      );

  Text showTitleH2white(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      );

  Text showTitleCart(String title) => Text(
        title,
        style: const TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: Colors.black45,
    // fontStyle: FontStyle.italic,
    fontFamily: 'FC-Minimal-Regular',
  ),
      );

  Text showTitleH3(String title) => Text(
        title,
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.blue.shade300,
          fontWeight: FontWeight.bold,
        ),
      );



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
            FlatButton(
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
            FlatButton(
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

  confirmDialog(
    BuildContext context,
    String textTitle,
    String textContent,
    Widget prossedYes,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [Text(textTitle)]),
          content: Text(textContent),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
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
            FlatButton(
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

  Container showlogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  BoxDecoration myBoxDecoration(String namePic) {
    return BoxDecoration(
      image: DecorationImage(
          image: AssetImage('images/$namePic'), fit: BoxFit.cover),
    );
  }

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
                  child:SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: const CircularProgressIndicator(
                      value: null,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      strokeWidth: 7.0,
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
