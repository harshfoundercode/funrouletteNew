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

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final nameCont = TextEditingController();
  final bankNameCon = TextEditingController();
  final accountNumberCon = TextEditingController();
  final branchCon = TextEditingController();
  final ifscCon = TextEditingController();

  bool loader = false;
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
                  "Add Account",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: ColorConstant.whiteColor,
                  height: height * 0.01,
                ),
                allTextfield("NAME", nameCont),
                allTextfield("BANK NAME", bankNameCon),
                allTextfield("ACCOUNT NUMBER", accountNumberCon,
                    keyboardType: TextInputType.number),
                allTextfield("BRANCH NAME", branchCon),
                allTextfield("IFSC CODE", ifscCon),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                            Size(width * 0.05, height * 0.09)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    loader == false
                        ? ElevatedButton(
                            style: ButtonStyle(
                              minimumSize: WidgetStateProperty.all(
                                  Size(width * 0.05, height * 0.09)),
                            ),
                            onPressed: () {
                              if(nameCont.text.isEmpty){
                                Utils.errorToastMessage("Enter your name", context);
                              } else if(bankNameCon.text.isEmpty){
                                Utils.errorToastMessage("Enter your bank name", context);
                              } else if(accountNumberCon.text.isEmpty){
                                Utils.errorToastMessage("Enter your account number", context);
                              } else if (branchCon.text.isEmpty){
                                Utils.errorToastMessage("Enter your branch name", context);
                              } else if (ifscCon.text.isEmpty){
                                Utils.errorToastMessage("Enter your ifsc code", context);
                              } else {
                                addAccount(
                                    context,
                                    nameCont.text,
                                    bankNameCon.text,
                                    accountNumberCon.text,
                                    branchCon.text,
                                    ifscCon.text);
                              }
                            },
                            child: const Text("Submit"),
                          )
                        : const Center(child: CircularProgressIndicator())
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget allTextfield(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return SizedBox(
      width: width * 0.40,
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
            width: width * 0.18,
            child: CustomTextField(
              controller: controller,
              textcolor: ColorConstant.darkBlackColor,
              filled: true,
              fillColor: ColorConstant.whiteColor,
              height: Platform.isWindows ? 40 : 20,
              textAlignVertical: TextAlignVertical.top,
              textInputAction: TextInputAction.done,
              margin: EdgeInsets.symmetric(vertical: height * 0.01),
            ),
          ),
        ],
      ),
    );
  }

  addAccount(context, String name, String bankname, String accountno,
      String branch, String ifsc) async {
    final user_id = Provider.of<UserProvider>(context, listen: false).user!.id;
    setState(() {
      loader = true;
    });
    final response = await http.post(
      Uri.parse(AppUrls.addacount),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "userid": user_id,
        "name": name,
        "account_number": accountno,
        "bank_name": bankname,
        "branch_name": branch,
        "ifsc_code": ifsc
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        loader = false;
      });
      Navigator.pop(context);
      Navigator.pop(context);
      return Utils.snackBar(responseData['message'], context);
    } else {
      setState(() {
        loader = false;
      });
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return Utils.snackBar(responseData['message'], context);
    }
  }
}
