import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funroullete_new/Constant/color.dart';
import 'package:funroullete_new/Provider/user_provider.dart';
import 'package:funroullete_new/Utils/message_utils.dart';
import 'package:funroullete_new/Views/Constant-Widgets/Container/Container_widget.dart';
import 'package:funroullete_new/Views/Constant-Widgets/Text%20Field/TextField_widget.dart';
import 'package:funroullete_new/Views/Constant-Widgets/TextStyling/smallTextStyle.dart';
import 'package:funroullete_new/api/auth-service-.dart';
import 'package:funroullete_new/main.dart';
import 'package:provider/provider.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<Login2> createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController password0 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: AssetImage("assets/assets/funrouletebg.png"),fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(right: width*0.55,top:Platform.isWindows?height*0.015:0),
                child: Small_Text(Title: context.read<AuthService>().responseMessage,fontSize: 13,textColor: Colors.deepOrange,),
              ),
              Padding(
                padding: EdgeInsets.only(top: height*0.634),
                child: SizedBox(
                  width: width*0.8,
                  height: height*0.30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: width*0.09),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Spacer(),
                              SizedBox(
                                width: width*0.2,
                                child: CustomTextField(
                                  controller: userName,
                                  textcolor: ColorConstant.darkBlackColor,
                                  filled: true,
                                  fillColor: ColorConstant.whiteColor,
                                  height: Platform.isWindows?50:30,
                                  textAlignVertical: TextAlignVertical.top,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              SizedBox(height: Platform.isWindows?height*0.03:height*0.02,),
                              SizedBox(
                                width: width*0.2,
                                child: CustomTextField(
                                  controller: password0,
                                  textcolor: ColorConstant.darkBlackColor,
                                  filled: true,
                                  fillColor: ColorConstant.whiteColor,
                                  height: Platform.isWindows?50:30,
                                  textAlignVertical: TextAlignVertical.top,
                                  textInputAction: TextInputAction.done,
                                ),
                              ),
                              SizedBox(height: Platform.isWindows?height*0.03:height*0.035,)
                            ],
                          ),
                          CustomContainer(
                            margin: const EdgeInsets.only(bottom: 10),
                            onTap: () async {
                              String username = userName.text.trim();
                              String password = password0.text.trim();
                              if (userName.text.isNotEmpty && password0.text.isNotEmpty) {
                                await context.read<UserProvider>().login(context,username, password);
                              } else {
                                Utils.snackBar("Must be enter valid details.", context);
                              }
                            },
                            widths: width*0.15,
                            height:height*0.10,
                            // color: Colors.red,
                          ),
                        ],
                      ),
                      SizedBox(width: width*0.12),
                      Padding(
                        padding:  EdgeInsets.only(top: height*0.2),
                        child: closeApp(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget closeApp() {
  return InkWell(
    onTap: () {Platform.isWindows?
    exit(0):
    SystemNavigator.pop();

    },
    child: Container(
      width: width*0.13,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        // color: Colors.red
      ),
    )
  );
}

