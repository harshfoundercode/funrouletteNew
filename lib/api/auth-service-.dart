import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:funroullete_new/Constant/shared_preference.dart';
import 'package:funroullete_new/Constant/url.dart';
import 'package:funroullete_new/Model/user-login-model.dart';
import 'package:funroullete_new/Utils/message_utils.dart';
import 'package:funroullete_new/Views/view2/home2.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {

  AuthService();

   String responseMessage = "Waiting for response....";

  Future<UserModel?> login(context,String username, String password) async {
    final response = await http.post(
      Uri.parse(AppUrls.loginApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if(responseData['status'].toString() == "200"){
        final Map<String, dynamic> userData = responseData['data'];
        final UserModel user = UserModel.fromJson(userData);
        SharedPreferencesUtil.setUserId(user.id);
        WidgetsBinding.instance.addPostFrameCallback((_){
          // Navigator.pushNamed(context, AppRoutes.dashboardScreen);
          Navigator.push(context,MaterialPageRoute(builder: (context)=>const HomeScreen2()));
        });
        responseMessage = responseData['message'];
        return user;
      }else{
        responseMessage = responseData['message'];
        Utils.snackBar(responseData['message'], context);
        return null;
      }
    } else {
      Utils.snackBar("Something went wrong api status code: ${response.statusCode}", context);
      if (kDebugMode) {
        print('Login failed: ${response.statusCode}');
      }
      return null;
    }
  }
}
