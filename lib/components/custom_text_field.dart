import 'package:epic/components/custom_text.dart';
import 'package:epic/consts/colors.dart';
import 'package:flutter/material.dart';

Widget customTextField({
  required String labeltext,
  String? hinttext,
  required TextInputType keyboardtype,
  required bool obscureText,
  required TextEditingController controller,
  required BuildContext context,
  required Color textcolor,
  required Color borderColor,
  Color? hintcolor,
  required double fontsize,
  required double textfieldfontsize,
  required FontWeight fontWeight,
  required TextAlign textalign,
  Color? backgroundColor,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      customTextWithAlignment(
          text: labeltext,
          fontweight: fontWeight,
          fontsize: fontsize,
          textcolor: textcolor,
          textalign: textalign),
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          color: backgroundColor ?? Colors.grey.withOpacity(.3),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextField(
          controller: controller,
          cursorColor: grey,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(
            color: black,
            fontSize: screenWidth > 360 ? 18 : 14,
          ),
          decoration: InputDecoration(
            hintText: hinttext,
            contentPadding: const EdgeInsets.only(left: 10),
            hintStyle: TextStyle(
              fontSize: screenWidth > 360 ? 18 : 14,
              fontWeight: FontWeight.w700,
              color: hintcolor ?? red,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    ],
  );
}
