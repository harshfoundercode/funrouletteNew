
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constant/color.dart';

class Text_Button extends StatelessWidget {
  final String? Title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;

  const Text_Button({super.key, this.Title, this.fontSize, this.fontWeight, this.textColor, this.onTap, this.padding}) ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Container(
        padding: padding,
        child: Text(
            Title==null?"Press Me!":Title!,
            style: GoogleFonts.alike(
              textStyle: TextStyle(
                  fontSize: fontSize ?? 15,
                  fontWeight:fontWeight ?? FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: textColor ?? ColorConstant.blueColor
              ),
            )),
      ),
    );

  }
}
