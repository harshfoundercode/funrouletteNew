

import 'package:flutter/material.dart';
import 'package:funroullete_new/Constant/assets.dart';
import 'package:funroullete_new/Constant/color.dart';
import 'package:funroullete_new/Views/Auth/login2.dart';
import 'package:funroullete_new/Views/Constant-Widgets/Container/Container_widget.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    splashTimer();
  }

  void splashTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login2()));
  }
  // void ff() {
  //   Timer(const Duration(seconds: 3), () {
  //     Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.darkBlackColor,
      body: CustomContainer(
        widths: double.infinity,
        height: double.infinity,
        image: const DecorationImage(
            image: AssetImage(Graphics.loginBg),fit: BoxFit.fill),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: Colors.red,
              gradient: LinearGradient(colors: [
                ColorConstant.darkBlackColor.withOpacity(0.9),
                ColorConstant.darkBlackColor.withOpacity(0.7),
                Colors.transparent,
                Colors.transparent,
                ColorConstant.darkBlackColor.withOpacity(0.7),
                ColorConstant.darkBlackColor.withOpacity(0.9)
              ])),
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appLogo(),
            ],
          ),
        ),
      ),
    );
  }
}
Widget appLogo() {
  return CustomContainer(
    boxShadow: [
      BoxShadow(
          offset: const Offset(2,2),
          color: ColorConstant.whiteColor.withOpacity(0.4),
          blurRadius: 2,
          spreadRadius: 1,
          blurStyle: BlurStyle.inner
      )
    ],
    borderRadius: BorderRadius.circular(15),
    padding: const EdgeInsets.all(10),
    height: 200,
    widths: 200,
    color: ColorConstant.darkBlackColor.withOpacity(0.6),
    image: const DecorationImage(
        image: AssetImage(Graphics.gameLogo),
        fit: BoxFit.fill
    ),
  );
}