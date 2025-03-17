import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

Widget customButton({
  required VoidCallback ontap,
  required backgroundcolor,
  required text,
  required double fontsize,
  double? radius,
  double? borderwidth,
  required Color textcolor,
  Color? borderColor,
  required FontWeight fontWeight,
  bool isLoading = false,
}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          // minimumSize: const Size(double.infinity, 40),
          backgroundColor: backgroundcolor,
          // side: BorderSide(color: borderColor, width: borderwidth),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 10),
          )),
      onPressed: ontap,
      child: isLoading
          ? CircularProgressIndicator(
              color: red,
            )
          : customTextWithAlignment(
              text: text,
              fontweight: fontWeight,
              fontsize: fontsize,
              textcolor: textcolor,
              textalign: TextAlign.center));
}
