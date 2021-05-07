import 'package:flutter/material.dart';

class MyStyle {
  Color darkColor = Color(0xff005400);
  Color primaryColor = Color(0xff39821a);
  Color lightColor = Color(0xff6bb249);

  TextStyle darkStyle() => TextStyle(color: darkColor);
  TextStyle whiteStyle() => TextStyle(color: Colors.white);
  TextStyle activeStyle() => TextStyle(
        color: Colors.yellow.shade400,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      );

      TextStyle pinkStyle() => TextStyle(
        color: Colors.pink.shade600,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      );

  Widget showLogo() => Image(
        image: AssetImage('images/logo.png'),
      );

  SafeArea buildBackground(double screenWidth, double screenHeight) {
    return SafeArea(
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image(image: AssetImage('images/top1.png')),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Image(image: AssetImage('images/top2.png')),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image(image: AssetImage('images/bottom1.png')),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image(image: AssetImage('images/bottom2.png')),
            ),
          ],
        ),
      ),
    );
  }

  MyStyle();
}
