import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:funroullete_new/Constant/color.dart';
import 'package:funroullete_new/Constant/url.dart';
import 'package:funroullete_new/Provider/user_provider.dart';
import 'package:funroullete_new/Utils/message_utils.dart';
import 'package:funroullete_new/Views/Constant-Widgets/Text%20Field/TextField_widget.dart';
import 'package:funroullete_new/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();

}

class _WithdrawScreenState extends State<WithdrawScreen> {

  final _amountCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                const Text(
                  "Withdraw",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: ColorConstant.whiteColor,height: height*0.01,),
                allTextfield("AMOUNT",_amountCont, keyboardType: TextInputType.number),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(width * 0.05, height * 0.09)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(width * 0.05, height * 0.09)),
                      ),
                      onPressed: () {
                        if(_amountCont.text.isEmpty){
                          Utils.errorToastMessage("Enter your amount", context);
                        } else {
                          withdrawalMoney(context,_amountCont.text);
                        }

                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget allTextfield(String label,TextEditingController controller,{TextInputType keyboardType = TextInputType.text}){
    return  SizedBox(
      width: width*0.40,
      // color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$label : ",
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: width*0.18,
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
          ),
        ],
      ),
    );
  }

  withdrawalMoney(context, String money) async {
    final user_id = Provider.of<UserProvider>(context, listen: false).user!.id;
    final response = await http.post(
      Uri.parse(AppUrls.withdraw),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "userid": user_id,
        "amount": money,
      }),
    );

    var data = jsonDecode(response.body);
    if (data["status"] == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      return Utils.flushBarSuccessMessage(data['message'], context);
    } else if (data["status"] == "401") {
    } else {
      Utils.flushBarErrorMessage(data['message'], context);
    }
  }
}

