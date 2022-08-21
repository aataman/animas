import 'package:flutter/material.dart';

class SolClipper extends CustomClipper<Rect> {
  double posX;

  SolClipper({required this.posX});

  @override
  Rect getClip(Size size) {
    // posX == 0 ? size.width / 2 : posX;
    // TODO: implement getClip
    // throw UnimplementedError();
    Rect rectSol = Rect.fromLTWH(0, 0, posX, size.height);
    return rectSol;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    // TODO: implement shouldReclip
    // throw UnimplementedError();
    return true;
  }
}
