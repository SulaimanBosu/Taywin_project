import 'package:flutter/material.dart';

class ScreenSize {
  String screenwidth(double screenwidth) {
    String screen = '';
    if (screenwidth >= 768) {
      screen = 'TABLET';
    } else {
      screen = 'MOBILE';
    }

    return screen;
  }

  screenheight(BuildContext context) {
    double screenheight = MediaQuery.of(context).size.height;
    String screen = '';
    if (screenheight >= 1024) {
      screen = 'TABLET';
    } else {
      screen = 'MOBILE';
    }

    return screen;
  }

  ScreenSize();
}
