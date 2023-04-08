import 'package:flutter/material.dart';

//To disable the scrolling glow
class MyScrollBehavior extends ScrollBehavior {
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
