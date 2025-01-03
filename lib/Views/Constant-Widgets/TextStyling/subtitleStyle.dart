
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constant/color.dart';

class SubTitle_Text extends StatelessWidget {
  final String? Title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? width;
  final TextAlign? textAlign;
  final int? maxLines;
  final bool? softWrap;
  final TextOverflow? overflow;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry? alignment;
  const SubTitle_Text({super.key, this.Title, this.fontSize, this.fontWeight, this.textColor, this.width, this.textAlign, this.maxLines, this.softWrap, this.overflow, this.padding, this.alignment}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      alignment:alignment ?? Alignment.center,
      child: Text(
        maxLines: maxLines,
          overflow: overflow,
        softWrap: softWrap,
        textAlign:textAlign,
          Title==null?"":Title!,
          style: GoogleFonts.ptSerif(
            textStyle: TextStyle(//15
                fontSize: fontSize ?? MediaQuery.of(context).size.width/45,
                fontWeight:fontWeight ?? FontWeight.normal,
                fontStyle: FontStyle.normal,
                color: textColor ?? ColorConstant.darkBlackColor,
            )
          )
      ),
    );
  }
}
