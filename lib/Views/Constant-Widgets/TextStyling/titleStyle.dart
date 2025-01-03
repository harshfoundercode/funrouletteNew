// ignore_for_file: non_constant_identifier_names


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constant/color.dart';

class TitleStyle extends StatelessWidget {
  final String? Title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? width;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final double? lineheight;

  const TitleStyle({super.key, this.Title, this.fontSize, this.fontWeight, this.textColor, this.textAlign, this.maxLines, this.softWrap, this.overflow,  this.width, this.alignment, this.padding, this.lineheight}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      alignment: alignment ?? Alignment.center,
      child: Text(
        maxLines: maxLines,
          overflow: overflow,
          softWrap: softWrap,
          textAlign:textAlign,
          Title==null?"":Title!,
          style: GoogleFonts.ptSerif(
            textStyle: TextStyle(
                fontSize: fontSize ?? MediaQuery.of(context).size.width/40,
                fontWeight:fontWeight ?? FontWeight.normal,
                fontStyle: FontStyle.normal,
                color: textColor ?? ColorConstant.whiteColor,
              height: lineheight
            ),
          )),
    );
  }
}
