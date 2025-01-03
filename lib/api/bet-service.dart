import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:funroullete_new/Constant/url.dart';
import 'package:funroullete_new/Utils/message_utils.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Provider/user_provider.dart';

class BetService with ChangeNotifier {
  BetService();

  Future<void> InsertBetApi(context,betJsonData) async {
    // final userId = SharedPreferencesUtil.getUserId();
    final userId = Provider.of<UserProvider>(context,listen: false).user!.id;

    final response = await http.post(
      Uri.parse(AppUrls.insertBetApiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userid': userId, 'bets': betJsonData}),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(jsonDecode(response.body));
      }
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['status'] == 200) {
        return Utils.toastMessage(responseData['message'],context);
      } else {
        return Utils.errorToastMessage(responseData['message'],context);
      }
    } else {
      if (kDebugMode) {
        print('Something went wrong: ${response.statusCode}');
      }
      return;
    }
  }
}
