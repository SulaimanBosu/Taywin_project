import 'package:flutter/material.dart';

class Sizes {
  List<String> man(double sizeheight) {
    List<String> man = [];

    if (sizeheight >= 29.1) {
      man = ['45 - 46', '12.5', '12'];
    } else if (sizeheight >= 28.6) {
      man = ['45', '12', '11.5'];
    } else if (sizeheight >= 28.3) {
      man = ['44 - 45', '11.5', '11'];
    } else if (sizeheight >= 27.9) {
      man = ['44', '11', '10.5'];
    } else if (sizeheight >= 27.3) {
      man = ['43 - 44', '10.5', '10'];
    } else if (sizeheight >= 27.0) {
      man = ['43', '10', '9.5'];
    } else if (sizeheight >= 26.7) {
      man = ['42 - 43', '9.5', '9'];
    } else if (sizeheight >= 26.0) {
      man = ['42', '9', '8.5'];
    } else if (sizeheight >= 25.7) {
      man = ['41 - 42', '8.5', '8'];
    } else if (sizeheight >= 25.4) {
      man = ['41', '8', '7.5'];
    } else if (sizeheight >= 24.8) {
      man = ['40 - 41', '7.5', '7'];
    } else if (sizeheight >= 24.4) {
      man = ['40', '7', '6.5'];
    } else if (sizeheight >= 24.1) {
      man = ['39 - 40', '6.5', '6'];
    } else if (sizeheight >= 23.6) {
      man = ['39', '6', '5.5'];
    } else if (sizeheight >= 23.2) {
      man = ['38 - 39', '5.5', '5'];
    } else if (sizeheight >= 22.7) {
      man = ['38', '5', '4.5'];
    } else if (sizeheight >= 22.2) {
      man = ['37 - 38', '4.5', '4'];
    } else if (sizeheight >= 21.7) {
      man = ['37', '4', '3.5'];
    } else if (sizeheight >= 21.2) {
      man = ['36 -37', '3.5', '3'];
    } else if (sizeheight >= 20.6) {
      man = ['36', '3', '2.5'];
    } else if (sizeheight <= 20.5) {
      man = ['35 - 36', '2.5', '2'];
    }
    return man;
  }

  List<String> woman(double sizeheight) {
    List<String> woman = [];

    if (sizeheight >= 29.7) {
      woman = ['44 - 45', '14', '12'];
    } else if (sizeheight >= 29.2) {
      woman = ['44', '13.5', '11.5'];
    } else if (sizeheight >= 28.7) {
      woman = ['43 - 44', '13', '11'];
    } else if (sizeheight >= 28.2) {
      woman = ['43', '12.5', '10.5'];
    } else if (sizeheight >= 27.7) {
      woman = ['42 - 43', '12', '10'];
    } else if (sizeheight >= 27.2) {
      woman = ['42', '11.5', '9.5'];
    } else if (sizeheight >= 26.7) {
      woman = ['41 - 42', '11', '9'];
    } else if (sizeheight >= 26.2) {
      woman = ['41', '10.5', '8.5'];
    } else if (sizeheight >= 25.9) {
      woman = ['40 - 41', '10', '8'];
    } else if (sizeheight >= 25.4) {
      woman = ['40', '9.5', '7.5'];
    } else if (sizeheight >= 25.1) {
      woman = ['39 - 40', '9', '7'];
    } else if (sizeheight >= 24.6) {
      woman = ['39', '8.5', '6.5'];
    } else if (sizeheight >= 24.1) {
      woman = ['38 - 39', '8', '6'];
    } else if (sizeheight >= 23.8) {
      woman = ['38', '7.5', '5.5'];
    } else if (sizeheight >= 23.5) {
      woman = ['37 - 38', '7', '5'];
    } else if (sizeheight >= 23.0) {
      woman = ['37', '6.5', '4.5'];
    } else if (sizeheight >= 22.5) {
      woman = ['36 - 37', '6', '4'];
    } else if (sizeheight >= 22.2) {
      woman = ['36', '5.5', '3.5'];
    } else if (sizeheight >= 21.6) {
      woman = ['35 - 36', '5', '3'];
    } else if (sizeheight <= 21.5) {
      woman = ['35', '4.5', '2.5'];
    }
    return woman;
  }

  Sizes();
}

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter(
      {this.strokeColor = Colors.black,
      this.strokeWidth = 3,
      this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 1, 0)
      ..lineTo(x, y * 2)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
