import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:funroullete_new/Constant/color.dart';
import 'package:funroullete_new/Constant/url.dart';
import 'package:funroullete_new/Provider/user_provider.dart';
import 'package:funroullete_new/Utils/message_utils.dart';
import 'package:funroullete_new/Views/Constant-Widgets/Text%20Field/TextField_widget.dart';
import 'package:funroullete_new/Views/view2/depositweb.dart';
import 'package:funroullete_new/main.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final amountCon = TextEditingController();
  bool loader = false;

  @override
  void initState() {
    HttpOverrides.global = MyHttpOverrides();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context, listen: false).user;

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
                  "Deposit",
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
                 Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Wallet: ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "₹${userDetails!.wallet}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                allTextfield("AMOUNT", amountCon,
                    keyboardType: TextInputType.number),
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
                    loader==false?
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                            Size(width * 0.05, height * 0.09)),
                      ),
                      onPressed: () {
                        if(amountCon.text.isEmpty){
                          Utils.errorToastMessage("Enter your amount", context);
                        } else {
                          addMoney(context,amountCon.text);
                        }
                      },
                      child: const Text("Submit"),
                    ):const Center(child: CircularProgressIndicator())
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
              label: "Enter your amount",
              hintSize: 10,

            ),
          ),
        ],
      ),
    );
  }


  addMoney(context,String depositCon) async {
    setState(() {
      loader = true;
    });
    final user_id = Provider.of<UserProvider>(context, listen: false).user!.id;

    final response = await http.post(
      Uri.parse(AppUrls.payin),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, String>{
        "userid":user_id,
        "amount":depositCon
      }),
    );
    final data = jsonDecode(response.body);
    var url = data['payment_link'].toString();
    if (response.statusCode==200) {
      setState(() {
        loader = false;
      });
      if (Platform.isWindows) {
        if(data['status']=='SUCCESS') {
          _launchURL(context, url);
        } else {
          Utils.flushBarErrorMessage(data["message"], context);
        }
      } else {
        if(data['status']=='SUCCESS'){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentWeb(
                      url: url
                  )));
        }
        else {
          Utils.flushBarErrorMessage(data["message"], context);
        }

      }
    } else {
      setState(() {
        loader = false;
      });
      Utils.flushBarErrorMessage(data["message"], context);
    }
  }

  _launchURL(context,String urlget) async {
    var url = urlget;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Utils.flushBarErrorMessage("Could not launch $url", context);
      throw "error: $url";
    }
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}