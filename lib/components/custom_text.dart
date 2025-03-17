import 'package:flutter/material.dart';

Widget customTextWithAlignment({
  required String text,
  required FontWeight fontweight,
  required double fontsize,
  required Color textcolor,
  required TextAlign textalign,
}) {
  return Text(
    textAlign: textalign,
    text,
    style: TextStyle(
      color: textcolor,
      fontWeight: fontweight,
      fontSize: fontsize,
    ),
  );
}

Widget customTextOne({
  required String text,
  required FontWeight fontweight,
  required double fontsize,
  required Color textcolor,
  TextAlign? alignment,
}) {
  return Text(
    textAlign: alignment,
    text,
    style: TextStyle(
      color: textcolor,
      fontWeight: fontweight,
      fontSize: fontsize,
    ),
  );
}

Widget customText(
    String text, FontWeight fontweight, double fontsize, Color color) {
  return Text(
    text,
    style: TextStyle(
        fontSize: fontsize,
        color: color,
        fontWeight: fontweight,
        fontFamily: 'Aboreto'),
  );
}
