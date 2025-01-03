import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Constant/color.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final InputDecoration? decoration = const InputDecoration();
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign textAlign = TextAlign.start;
  final TextAlignVertical? textAlignVertical;
  final TextDirection? textDirection;
  final bool readOnly = false;
  final int? maxLines;
  final int? minLines;
  final bool expands = false;
  final int? maxLength;
  final bool obscureText = false;
  final TextInputType? keyboardType;
  final Widget? icon;
  final Color? iconColor;
  final String? label;
  final bool? filled;
  final Color? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final void Function(String)? onChanged;
  final double? height;
  final double? width;
  final double? hintSize;
  final double? fontSize;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? contentPadding;
  final double? cursorHeight;
  final Color? cursorColor;
  final Widget? prefix;
  final Widget? sufix;
  final BorderRadius? fieldRadius;
  final bool? enabled;
  final void Function()? onTap;
  final bool? autofocus;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? margin;
  final Color? hintColor;
  final String? errorText;
  final BorderSide? borderSide;
  final Color? textcolor;
  final TextInputAction? textInputAction;

  CustomTextField({super.key, this.controller,
    this.style,
    this.strutStyle,
    this.textAlignVertical,
    this.textDirection,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.icon,
    this.iconColor,
    this.label,
    this.filled,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.onChanged,
    this.height,
    this.width,
    this.hintSize,
    this.fontSize,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.contentPadding,
    this.cursorHeight,
    this.cursorColor,
    this.prefix,
    this.sufix,
    this.fieldRadius,
    this.enabled,
    this.maxLines,
    this.onTap,
    this.autofocus,
    this.onSaved,
    this.validator,
    this.margin, this.hintColor, this.errorText, this.borderSide, this.textcolor, this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin:margin,
        height:height ?? 50 ,
        width:width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border:border,
          borderRadius:borderRadius,
          boxShadow: boxShadow,
        ),
        child: TextFormField(
          validator:validator ,
          onSaved: onSaved,
          autofocus:autofocus??false,
          textAlignVertical: TextAlignVertical.center,
          enabled: enabled,
          controller: controller,
          cursorColor: cursorColor,
          cursorHeight: cursorHeight,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          expands: expands,
          readOnly: readOnly,
          obscureText: obscureText,
          keyboardType: keyboardType,
            textInputAction: textInputAction,
            style:style ?? GoogleFonts.alike(
              textStyle: TextStyle(
                  fontSize:fontSize ?? 13,
                  fontWeight:FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color: textcolor??ColorConstant.darkBlackColor
              ),
            ),
          decoration: InputDecoration(
            errorText: errorText,
            counterText: "",
            prefixIcon:prefix,
            suffixIcon: sufix,
            filled: filled ?? true,
            fillColor: fillColor??ColorConstant.greyColor.withOpacity(0.1),
            hintText: label,
            hintStyle: GoogleFonts.alike(
              textStyle: TextStyle(
                  fontSize:hintSize ?? 15,
                  fontWeight:FontWeight.normal,
                  fontStyle: FontStyle.normal,
                  color:hintColor ?? ColorConstant.greyColor
              ),
            ),
            contentPadding:contentPadding ?? const EdgeInsets.only(left: 7, right: 15, top: 0, bottom: 0),
            border: OutlineInputBorder(
              borderSide:borderSide==null? BorderSide(width:1, color: ColorConstant.whiteColor.withOpacity(0.5)):borderSide!,
                  borderRadius:fieldRadius== null? const BorderRadius.all(Radius.circular(4.0)):fieldRadius!
            ),
            focusedBorder: OutlineInputBorder(
                borderSide:borderSide==null? BorderSide(width:1, color: ColorConstant.whiteColor.withOpacity(0.5)):borderSide!,
                borderRadius:fieldRadius== null? const BorderRadius.all(Radius.circular(4.0)):fieldRadius!
            ),
            disabledBorder: OutlineInputBorder(
                borderSide:borderSide==null? BorderSide(width:1, color: ColorConstant.whiteColor.withOpacity(0.5)):borderSide!,
                borderRadius:fieldRadius== null? const BorderRadius.all(Radius.circular(4.0)):fieldRadius!
            ),
            enabledBorder: OutlineInputBorder(
                borderSide:borderSide==null? BorderSide(width:1, color: ColorConstant.whiteColor.withOpacity(0.5)):borderSide!,
                borderRadius:fieldRadius== null? const BorderRadius.all(Radius.circular(4.0)):fieldRadius!
            ),
          ),
        ),
      ),
    );
  }
}
