import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:funroullete_new/Constant/color.dart';
import 'package:funroullete_new/Constant/url.dart';
import 'package:funroullete_new/Provider/user_provider.dart';
import 'package:funroullete_new/Utils/message_utils.dart';
import 'package:funroullete_new/Views/Constant-Widgets/TextStyling/smallTextStyle.dart';
import 'package:funroullete_new/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewAccount(context);
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: width * 0.55,
          height: height * 0.70,
          decoration: BoxDecoration(
            color: Colors.brown.shade900,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  BackButton(color: ColorConstant.whiteColor,),
                   Padding(
                     padding:  EdgeInsets.only(left: width*0.15),
                     child: Text(
                      "MY DETAILS",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                                       ),
                   ),
                ],
              ),
              Divider(
                color: ColorConstant.whiteColor,
                height: height * 0.001,
              ),
              SizedBox(
                width: width*0.40,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Small_Text(Title: "Name:",fontSize: 14,fontWeight: FontWeight.bold,),
                        Small_Text(Title: name.toString(),fontWeight: FontWeight.w600,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Small_Text(Title:
                        "Account Number:",fontSize: 14,fontWeight: FontWeight.bold),
                        Small_Text(Title: account_no.toString(),fontWeight: FontWeight.w600),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Small_Text(Title: "Bank Name:",fontSize: 14,fontWeight: FontWeight.bold),
                        Small_Text(Title: bank_name.toString(),fontWeight: FontWeight.w600),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Small_Text(Title: "Branch:",fontSize: 14,fontWeight: FontWeight.bold),
                        Small_Text(Title: branch_name.toString(),fontWeight: FontWeight.w600),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Small_Text(Title: "IFSC:",fontSize: 14,fontWeight: FontWeight.bold,),
                        Small_Text(Title: ifsc_code.toString(),fontWeight: FontWeight.w600,),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: height*0.02,),
            ],
          ),
        ),
      ),
    );
  }


  dynamic name;
  dynamic account_no;
  dynamic bank_name;
  dynamic branch_name;
  dynamic ifsc_code;

  viewAccount(context) async {
    final user_id = Provider.of<UserProvider>(context, listen: false).user!.id;
    final response = await http.get(Uri.parse(AppUrls.viewAccount+user_id),);
    final Map<String, dynamic> responseData = jsonDecode(response.body)['data'];
    if (response.statusCode == 200) {
      setState(() {
        name = responseData['name'];
        account_no = responseData['account_no'];
        bank_name = responseData['bank_name'];
        branch_name = responseData['branch_name'];
        ifsc_code = responseData['ifsc_code'];
      });
      Utils.snackBar(responseData['message'], context);
    } else {
      Utils.snackBar(responseData['message'], context);
    }
  }

}
