import 'dart:io';

import 'package:flutter/material.dart';
import 'package:funroullete_new/Constant/color.dart';
import 'package:funroullete_new/Views/Constant-Widgets/Text%20Field/TextField_widget.dart';
import 'package:funroullete_new/main.dart';


class PopupScreen2 extends StatefulWidget {
  const PopupScreen2({super.key});

  @override
  State<PopupScreen2> createState() => _PopupScreen2State();
}

class _PopupScreen2State extends State<PopupScreen2> {

  final _accountNo = TextEditingController();
  final _pinCont = TextEditingController();
  final _amountCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/assets/popupTwo.png"),fit: BoxFit.fill),
          ),
          child:  Padding(
            padding:  EdgeInsets.only(bottom: height*0.07,left:width*0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                allTextfield(_accountNo),
                allTextfield(_pinCont),
                allTextfield(_amountCont),
                closeApp(context)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
Widget closeApp(context) {
  return InkWell(
      onTap: () {
      Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.only(left: width*0.144),
        child: SizedBox(
          height: height*0.05,
          width: width*0.05,
          // color: Colors.red,
        ),
      )
  );
}

Widget allTextfield(TextEditingController controller){
  return  SizedBox(
    width: width*0.15,
    child: CustomTextField(
      controller: controller,
      textcolor: ColorConstant.darkBlackColor,
      filled: true,
      fillColor: ColorConstant.whiteColor,
      height: Platform.isWindows?40:20,
      textAlignVertical: TextAlignVertical.top,
      textInputAction: TextInputAction.done,
      margin: EdgeInsets.symmetric(vertical: height*0.01),
    ),
  );
}