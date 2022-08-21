import 'package:flutter/material.dart';

class SagClipper extends CustomClipper<Rect> {
  double posX;

  SagClipper({required this.posX});

  @override
  Rect getClip(Size size) {
    // TODO: implement getClip
    // throw UnimplementedError();
    Rect rectSag = Rect.fromLTWH(posX, 0, size.width, size.height);
    return rectSag;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    //  throw UnimplementedError();
    return true;
  }
}
