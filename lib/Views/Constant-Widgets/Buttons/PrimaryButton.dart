// ignore_for_file: must_be_immutable


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constant/color.dart';

class PrimaryButton extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Color? gradientColorOne;
  final Color? gradientColorTwo;
  final Color? shadowColor;
  final double? dx;
  final double? dy;
  final Gradient? gradient;
  final String? Label;
  final TextStyle? style;
  final IconData? icon;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final Color? iconColor;
  final Color? textColor;
  final double? fontSize;
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final double? blurRadius;
  final double? spreadRadius;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final void Function()? onTap;
  final double? space;
  final double? iconSize;
  final List<BoxShadow>? boxShadow;
  bool? isClicked;
  final BoxShape? shape;
  final bool? inCol;
  PrimaryButton(
      {super.key, this.alignment,
      this.padding,
      this.color,
      this.decoration,
      this.width,
      this.height,
      this.margin,
      this.gradientColorOne,
      this.gradientColorTwo,
      this.shadowColor,
      this.dx,
      this.dy,
      this.gradient,
      this.Label,
      this.style,
      this.icon,
      this.fontWeight,
      this.fontStyle,
      this.iconColor,
      this.textColor,
      this.fontSize,
      this.begin,
      this.end,
      this.blurRadius,
      this.spreadRadius,
      this.child,
      this.borderRadius,
      this.onTap,
      this.space,
      this.iconSize,
      this.boxShadow,
      this.isClicked,
      this.shape,
      this.inCol});

  @override
  Widget build(BuildContext context) {
    final widths = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        alignment: Alignment.center,
        padding: padding,
        height: height ?? 40,
        width: width ?? widths,
        decoration: BoxDecoration(
            shape: shape == null ? BoxShape.rectangle : shape!,
            borderRadius:
                borderRadius ?? BorderRadius.circular(5),
            color: color ?? ColorConstant.primaryColor,
            gradient: gradient,
            boxShadow: boxShadow),
        child: child ?? (icon == null
                ? Text(
                    Label == null ? "" : Label!,
                    style: GoogleFonts.alike(
                        textStyle: TextStyle(
                            color: textColor ?? ColorConstant.whiteColor,
                            fontSize: fontSize,
                            fontWeight: fontWeight ?? FontWeight.w500)),
                    textAlign: TextAlign.center,
                  )
                : inCol == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: iconColor ?? ColorConstant.whiteColor,
                            size: iconSize,
                          ),
                          SizedBox(
                            width: space ?? 5,
                          ),
                          Text(
                            Label == null ? "" : Label!,
                            style: GoogleFonts.alike(
                                textStyle: TextStyle(
                                    color: textColor ?? ColorConstant.whiteColor,
                                    fontSize: fontSize,
                                    fontWeight: fontWeight ?? FontWeight.w500)),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            color: iconColor ?? ColorConstant.whiteColor,
                            size: iconSize,
                          ),
                          SizedBox(
                            width: space ?? 5,
                          ),
                          Text(
                            Label == null ? "" : Label!,
                            style: GoogleFonts.alike(
                                textStyle: TextStyle(
                                    color: textColor ?? ColorConstant.whiteColor,
                                    fontSize: fontSize,
                                    fontWeight: fontWeight ?? FontWeight.w500)),
                          ),
                        ],
                      )),
      ),
    );
  }
}
