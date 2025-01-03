
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constant/color.dart';

class HeadingOne extends StatelessWidget {
  final String? Title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  final TextAlign? textAlign;
   const HeadingOne({super.key, this.Title, this.fontSize, this.fontWeight, this.textColor, this.width, this.padding, this.alignment, this.textAlign}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      width: width,
      alignment:alignment ?? Alignment.centerLeft,
      child: Text(
        Title==null?"":Title!,
        style: GoogleFonts.ptSans(
          textStyle: TextStyle(//MediaQuery.of(context).size.width/20//22
            fontSize: fontSize ?? 22,
            fontWeight:fontWeight ?? FontWeight.normal,
            fontStyle: FontStyle.normal,
              color: textColor ?? ColorConstant.whiteColor
          ),
        ),
        textAlign:textAlign,
      ),
    );
  }
}
