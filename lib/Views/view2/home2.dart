import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funroullete_new/Constant/url.dart';
import 'package:funroullete_new/Model/transaction_history_model.dart';
import 'package:funroullete_new/Provider/user_provider.dart';
import 'package:funroullete_new/Views/view2/point_transfer_screen.dart';
import 'package:funroullete_new/Views/Constant-Widgets/TextStyling/smallTextStyle.dart';
import 'package:funroullete_new/Views/fun_target/Game-Home/home_screen.dart';
import 'package:funroullete_new/Views/view2/setting2.dart';
import 'package:funroullete_new/generated/assets.dart';
import 'package:funroullete_new/main.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {

  int? responseStatuscode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    transactionHistory();
  }
  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<UserProvider>(context, listen: false).user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/assets/homebgTwo.png"),fit: BoxFit.fill),
        ),
        child: Column(
            children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.0001,right: width*0.28),
            child: Container(
              height: height*0.09,
              width: width*0.37,
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Small_Text(Title: userDetails!.username),
                  Small_Text(Title: userDetails.wallet),
                ],
              ),
            ),
          ),
          Container(
            height: height*0.47,
            // color: Colors.pink,
            child: Row(
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: height*0.34,left: width*0.135),
                  child: InkWell(
                    onTap: (){
                      showDialog(context: context, builder: (context)=>const SettingScreen2());
                    },
                    child: Container(
                      height: height*0.12,
                      width: width*0.07,
                      // color: Colors.red.withOpacity(0.3),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(left: width*0.21),
                  child: Container(
                    height: height*0.47,
                    width: width*0.57,
                    // color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => const PopupScreen2());
                          },
                          child: Container(
                            height: height * 0.27,
                            width: width * 0.20,
                            decoration: const BoxDecoration(
                                // color: Colors.yellow,
                                shape: BoxShape.circle),
                          ),
                        ),
                        Container(
                          // color: Colors.red,
                          height: height * 0.38,
                          width: width * 0.15,
                          child: ListView.builder(
                              itemCount: 10,
                              physics: const ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePageScreen()));
                                  },
                                  leading: Container(
                                    height: height * 0.06,
                                    width: width * 0.03,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white, width: 1),
                                        shape: BoxShape.rectangle,
                                        image: const DecorationImage(
                                            image: AssetImage(Assets.assetsGamelogo),
                                            fit: BoxFit.fill)),
                                  ),
                                  title: const Small_Text(
                                    Title: "Fun Target",
                                    fontSize: 10,
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height*0.069,),
              Container(
            height: height*0.26,
            width: width*0.87,
            // color: Colors.orange,
            child: ListView.builder(
                itemCount: transactionItem.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                padding: const EdgeInsets.all(10),
                itemBuilder: (BuildContext context,int index){
                  var showItems = transactionItem[index];
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: width*0.13,
                      // color: Colors.red,
                      child: Text("Type: ${showItems.type}",style:const TextStyle(fontSize: 12,color: Colors.white),)
                  ),
                  Container(
                      width: width*0.13,
                      // color: Colors.pink,
                      child: Text("Amount: ₹${showItems.amount ?? "0"}",style:const TextStyle(fontSize: 12,color: Colors.white),)),
                  Container(
                      width: width*0.24,
                      // color: Colors.red,
                      child: Text("Orderid: ${showItems.orderid ?? "0"}",style:const TextStyle(fontSize: 12,color: Colors.white),)),
                  Container(
                    width: width*0.2,
                    // color: Colors.pink,
                    child: Text("Datetime: ${DateFormat("dd-MM-yyyy").format(
                    DateTime.parse('${showItems.datetime}'))}",style:const TextStyle(fontSize: 12,color: Colors.white),),
                  ),
                ],
              );
            }),
          ),
          Padding(
            padding: EdgeInsets.only(left: width * 0.78,top: height*0.04),
            child: InkWell(
              onTap: () {
                Platform.isWindows ? exit(0) : SystemNavigator.pop();
              },
              child: SizedBox(
                width: width * 0.09,
                height: height * 0.05,
                // color: Colors.red,
              ),
            )
          ),

        ]),
      ),
    );
  }

  List<TransactionHistoryModel> transactionItem = [];

  Future<void> transactionHistory() async {
    final user_id = Provider.of<UserProvider>(context, listen: false).user!.id;

    final response = await http.get(Uri.parse('${AppUrls.transactionHistory}$user_id'));
    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode==200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        transactionItem = responseData.map((item) => TransactionHistoryModel.fromJson(item)).toList();
      });
    }
    else if(response.statusCode==400){
      if (kDebugMode) {
        print('Data not found');
      }
    }
    else {
      setState(() {
        transactionItem = [];
      });
      throw Exception('Failed to load data');
    }
  }

}


